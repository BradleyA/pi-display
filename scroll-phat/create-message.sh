#!/bin/bash
# 	create-message.sh  3.04.75  2018-03-03_16:38:38_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.03  
# 	   clean out a lot of errors; adding SYSTEM file as example; need to update README about example file 
# 	create-message.sh  3.03.74  2018-03-03_15:40:43_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.02  
# 	   create-message.sh add error code closes #2 
# 	create-message.sh  3.02.73  2018-03-03_15:09:01_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.01-4-g76bea75  
# 	   create-message.sh move copy of MESSAGE file to remote systems after being updated close #3 
# 	create-message.sh  3.01.68  2018-03-03_14:19:20_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.16  
# 	   create-message.sh add support for comment in SYSTEMS file closes #5 
# 	create-message.sh  2.16.67  2018-03-03_12:06:15_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.15-1-ge4d4c65  
# 	   add failover automation support, closes #1 
#
#	set -x
#	set -v
###
display_help() {
echo -e "\n${0} - stores information about containers and images"
echo -e "\n   >>> UNDER DEVELOPMENT  . . . .  ."
echo -e "\nUSAGE\n   ${0} [<cluster>] [<administrator>] [<data_directory>] [<sshport>"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nThis script stores Docker information about containers and images in a file"
echo    "on each system in a cluster.  These files are copied to a host and totaled"
echo    "in a file, /usr/local/data/cluster-1/MESSAGE.  The MESSAGE file includes the"
echo    "total number of conntainers, running containers, paused containers, stopped"
echo    "containers, and number of images.  The MESSAGE file is used to display the"
echo    "information on a Raspberry Pi Scroll-pHAT display."
echo -e "\n   >>>   NEED to finish this... run script in a container every two minutes on a Raspberry Pi that includes Scroll-pHAT display."
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
CLUSTER=${1:-cluster-1/}
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
	mkdir -p  ${DATA_DIR}${CLUSTER} || { echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	User ${ADMUSER} does not have permission to create ${DATA_DIR}${CLUSTER} directory" ; exit 1; }
fi
#	Create MESSAGE file 1) create file for initial running on host, 2) check for write permission
touch ${DATA_DIR}${CLUSTER}/MESSAGE  || { echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]: User ${ADMUSER} does not have permission to create MESSAGE file" ; exit 1; }
#       Check if SYSTEMS file on system
#	one FQDN per line for all hosts in cluster
if ! [ -e ${DATA_DIR}${CLUSTER}/SYSTEMS ] || ! [ -s ${DATA_DIR}${CLUSTER}/SYSTEMS ] ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:\tSYSTEMS file missing or empty, creating SYSTEMS file with local host.\n" 1>&2
	echo -e "\tEdit ${DATA_DIR}${CLUSTER}/SYSTEMS file and add additional hosts in cluster."
	hostname -f > ${DATA_DIR}${CLUSTER}/SYSTEMS
fi
#	loop through host in SYSTEM file for cluster
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS | grep -v "#" ); do
#	Check if ${NODE} is ${LOCALHOST} don't use ssh and scp
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on port ${SSHPORT}
		if $(nc -z ${NODE} ${SSHPORT} >/dev/null) ; then
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
			DISK=$(ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE} 'df -h  | grep -m 1 "^/"')
			DISK=$(echo ${DISK} | awk '{printf "Disk_Usage: %d/%dGB %s\n", $3,$2,$5}')
			TEMP="echo ${MEMORY} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo ${DISK} >> ${DATA_DIR}${CLUSTER}/${NODE}"
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
		DISK=$(df -h | awk '$NF=="/"{printf "Disk_Usage: %d/%dGB %s\n", $3,$2,$5}')
		echo ${DISK} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
	fi
	CONTAINERS=`grep -i CONTAINERS ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$CONTAINERS '{print $2 + v}'`
	RUNNING=`grep -i RUNNING ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$RUNNING '{print $2 + v}'`
	PAUSED=`grep -i PAUSED ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$PAUSED '{print $2 + v}'`
	STOPPED=`grep -i STOPPED ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$STOPPED '{print $2 + v}'`
	IMAGES=`grep -i IMAGES ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$IMAGES '{print $2 + v}'`
done
MESSAGE=" CONTAINERS ${CONTAINERS}  RUNNING ${RUNNING}  PAUSED ${PAUSED}  STOPPED ${STOPPED}  IMAGES ${IMAGES} "
echo ${MESSAGE} > ${DATA_DIR}${CLUSTER}/MESSAGE
#	loop through host in SYSTEM file for cluster to update MESSAGE file on remote hosts
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS | grep -v "#" ); do
#	Check if ${NODE} is ${LOCALHOST} skip already did before the loop
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on port ${SSHPORT}
		if $(nc -z ${NODE} ${SSHPORT} >/dev/null) ; then
			scp -q    -i ~/.ssh/id_rsa -P ${SSHPORT} ${DATA_DIR}${CLUSTER}/MESSAGE ${ADMUSER}@${NODE}:${DATA_DIR}${CLUSTER}
		else
			echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:  ${NODE} found in ${DATA_DIR}${CLUSTER}/SYSTEMS file is not responding on port ${SSHPORT}.\n"   1>&2
		fi
	fi
done
echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Done.\n"	1>&2
###
