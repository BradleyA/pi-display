#!/bin/bash
# 	create-message.sh  3.28.130  2018-07-10_21:34:59_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.27  
# 	   add main/test1/create-message.sh memory for CPU and GPU close #9 
#
#	set -x
#	set -v
###
display_help() {
echo -e "\n${0} - Store Docker and system information"
echo -e "\nUSAGE\n   ${0} [<cluster>] [<administrator>] [<data_directory>] [<sshport>"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nThis script stores Docker information about containers and images in a file"
echo    "on each system in a cluster.  These files are copied to a host and totaled"
echo    "in a file, /usr/local/data/<cluster-name>/MESSAGE.  The MESSAGE file includes"
echo    "the total number of containers, running containers, paused containers,"
echo    "stopped containers, and number of images.  The MESSAGE file is used by a"
echo    "Raspberry Pi Scroll-pHAT to display the information."
echo -e "\nThis script reads /usr/local/data/<cluster-name>/SYSTEMS file for the names"
echo    "of the hosts in a cluster.  The file includes one FQDN host per line.   Lines"
echo    "starting with a '#' are ignored."
echo -e "\nSystem inforamtion about each host is stored in"
echo    "/usr/local/data/<cluster-name>/<host>.  The system information includes cpu"
echo    "temperature in Celsius and Fahrenheit, the system load, memory usage, and disk"
echo    "usage.  The system information will be used by blinkt to display system"
echo    "information about each system in near real time."
echo -e "\nTo avoid many login prompts for each host in a cluster, enter the following:"
echo    "ssh-copy-id uadmin@<host-name>"
echo -e "\nOPTIONS"
echo    "   CLUSTER   name of cluster directory, dafault cluster-1/"
echo    "   ADMUSER   site SRE administrator, default is user running script"
echo    "   DATA_DIR  path to cluster directory, dafault /usr/local/data/"
echo    "   SSHPORT   SSH server port, default port 22"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display-board"
echo -e "\nEXAMPLES"
echo -e "   Store information for a different cluster\n\t${0} cluster-2\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] || [ "$1" == "version" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
### 
CLUSTER=${1:-cluster-1}
ADMUSER=${2:-${USER}}
DATA_DIR=${3:-/usr/local/data/}
SSHPORT=${4:-22}
CONTAINERS=0
RUNNING=0
PAUSED=0
STOPPED=0
IMAGES=0
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
LOCALHOST=`hostname -f`
###
#       Check if cluster directory on system
if [ ! -d ${DATA_DIR}${CLUSTER} ] ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:\tCreating missing directory: ${DATA_DIR}${CLUSTER}\n" 1>&2
	mkdir -p  ${DATA_DIR}${CLUSTER} || { echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  User ${ADMUSER} does not have permission to create ${DATA_DIR}${CLUSTER} directory" ; exit 1; }
	chmod 775 ${DATA_DIR}${CLUSTER}
fi
#	Create MESSAGE file 1) create file for initial running on host, 2) check for write permission
touch ${DATA_DIR}${CLUSTER}/MESSAGE  || { echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  User ${ADMUSER} does not have permission to create MESSAGE file" ; exit 1; }
#       Check if SYSTEMS file on system
#	one FQDN per line for all hosts in cluster
if ! [ -e ${DATA_DIR}${CLUSTER}/SYSTEMS ] || ! [ -s ${DATA_DIR}${CLUSTER}/SYSTEMS ] ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:\tSYSTEMS file missing or empty, creating SYSTEMS file with local host.\n" 1>&2
	echo -e "\tEdit ${DATA_DIR}${CLUSTER}/SYSTEMS file and add additional hosts that are in the cluster.\n"
	hostname -f > ${DATA_DIR}${CLUSTER}/SYSTEMS
fi
#	Loop through host in SYSTEMS file
echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  Loop through hosts in SYSTEMS file"	1>&2
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS | grep -v "#" ); do
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  ${NODE}"	1>&2
#	Check if ${NODE} is ${LOCALHOST} don't use ssh and scp
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on port ${SSHPORT}
		if $(nc -z ${NODE} ${SSHPORT} >/dev/null) ; then
#       Check if cluster directory on system
			TEMP="mkdir -p  ${DATA_DIR}${CLUSTER}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${TEMP}
			TEMP="chmod 775 ${DATA_DIR}${CLUSTER}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${TEMP}
			TEMP="docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${TEMP}
			TEMP="/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//'"
			CELSIUS=$(ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${TEMP})
			FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
			TEMP="echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${TEMP}
			UPTIME="uptime | sed -s 's/^.*:/System_Load:/' >> ${DATA_DIR}${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${UPTIME}
			MEMORY=$(ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} 'free -m | grep Mem:')
			MEMORY=$(echo ${MEMORY} | awk '{printf "Memory_Usage: %s/%sMB %.2f%%\n", $3,$2,$3*100/$2 }')

			MEMORY2=$(ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} 'vcgencmd get_mem arm')
			MEMORY2=$(echo ${MEMORY2} | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')
			MEMORY3=$(ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} 'vcgencmd get_mem gpu')
			MEMORY3=$(echo ${MEMORY3} | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')

			DISK=$(ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} 'df -h  | grep -m 1 "^/"')
			DISK=$(echo ${DISK} | awk '{printf "Disk_Usage: %d/%dGB %s\n", $3,$2,$5}')
			TEMP="echo ${MEMORY} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo ${MEMORY2} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo ${MEMORY3} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo ${DISK} >> ${DATA_DIR}${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${TEMP}
			scp -q    -i ~/.ssh/id_rsa -P ${SSHPORT} ${ADMUSER}@${NODE}:${DATA_DIR}${CLUSTER}/${NODE} ${DATA_DIR}${CLUSTER}
			scp -q    -i ~/.ssh/id_rsa -P ${SSHPORT} ${DATA_DIR}${CLUSTER}/SYSTEMS ${ADMUSER}@${NODE}:${DATA_DIR}${CLUSTER}
		else
			echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:  ${NODE} found in ${DATA_DIR}${CLUSTER}/SYSTEMS file is not responding on port ${SSHPORT}.\n"   1>&2
			touch ${DATA_DIR}${CLUSTER}/${NODE}
		fi
	else
		docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		CELSIUS=$(/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//')
		echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
		echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		UPTIME=$(uptime | sed -s 's/^.*:/System_Load:/')
		echo ${UPTIME} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		MEMORY=$(free -m | awk 'NR==2{printf "Memory_Usage: %s/%sMB %.2f%%\n", $3,$2,$3*100/$2 }')
		echo ${MEMORY} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}

		MEMORY2=$(vcgencmd get_mem arm | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')
		echo ${MEMORY2} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		MEMORY3=$(vcgencmd get_mem gpu | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')
		echo ${MEMORY3} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}

		DISK=$(df -h | awk '$NF=="/"{printf "Disk_Usage: %d/%dGB %s\n", $3,$2,$5}')
		echo ${DISK} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
	echo "-->	create soft link	<--"
		cd ${DATA_DIR}${CLUSTER}
		ln -sf ${LOCALHOST} LOCAL-HOST
	fi
	CONTAINERS=`grep -i CONTAINERS ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$CONTAINERS '{print $2 + v}'`
	RUNNING=`grep -i RUNNING ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$RUNNING '{print $2 + v}'`
	PAUSED=`grep -i PAUSED ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$PAUSED '{print $2 + v}'`
	STOPPED=`grep -i STOPPED ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$STOPPED '{print $2 + v}'`
	IMAGES=`grep -i IMAGES ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$IMAGES '{print $2 + v}'`
done
MESSAGE=" CONTAINERS ${CONTAINERS}  RUNNING ${RUNNING}  PAUSED ${PAUSED}  STOPPED ${STOPPED}  IMAGES ${IMAGES} "
echo ${MESSAGE} > ${DATA_DIR}${CLUSTER}/MESSAGE
#	Loop through hosts in SYSTEMS file and update other host information
echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  Loop through hosts in SYSTEMS file and update other host information"	1>&2
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS | grep -v "#" ); do
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  ${NODE}"	1>&2
#	Check if ${NODE} is ${LOCALHOST} skip already did before the loop
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on port ${SSHPORT}
		if $(nc -z ${NODE} ${SSHPORT} >/dev/null) ; then
			scp -q    -i ~/.ssh/id_rsa -P ${SSHPORT} ${DATA_DIR}${CLUSTER}/* ${ADMUSER}@${NODE}:${DATA_DIR}${CLUSTER}
			TEMP="cd ${DATA_DIR}${CLUSTER} ; ln -sf ${NODE} LOCAL-HOST"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} ${TEMP}
		else
			echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:  ${NODE} found in ${DATA_DIR}${CLUSTER}/SYSTEMS file is not responding on port ${SSHPORT}.\n"   1>&2
		fi
	fi
done
echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  Done.\n"	1>&2
###
