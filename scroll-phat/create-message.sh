#!/bin/bash
# 	create-message.sh  2.14.64  2018-03-02_15:19:54_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.13  
# 	   added labels for Celsius, Fahrenheit, & System_load: to remote hosts 
# 	create-message.sh  2.13.63  2018-03-02_14:22:31_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.12-2-g162f35e  
# 	   added labels for Celsius, Fahrenheit, & System_load: to local host 
# 	create-message.sh  2.12.60  2018-03-01_18:40:08_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.11  
# 	   add uptime to tracking file 
# 	create-message.sh  2.11.59  2018-03-01_18:09:13_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.10  
# 	   added local host to cpu temperature 
# 	create-message.sh  2.10.58  2018-03-01_17:43:39_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.9-9-g309bc8c  
# 	   create-message.sh added cpu temperature 
# 	create-message.sh	2.5.35	2018-02-26_19:38:46_CST uadmin three-rpi3b.cptx86.com 2.4-1-gd14768e 
# 	   worked the help and completed testing, 2 programs work 
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
	mkdir -p  ${DATA_DIR}${CLUSTER}
fi
#       Check if SYSTEMS file on system
#	one FQDN per line for all hosts in cluster
if ! [ -e ${DATA_DIR}${CLUSTER}/SYSTEMS ] ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:\tSYSTEMS file missing, creating SYSTEMS file with local host.\n" 1>&2
	echo -e "\tAdd hosts that are in cluster into file."
	hostname -f > ${DATA_DIR}${CLUSTER}/SYSTEMS
fi
#	Create missing host files from list in SYSTEM file
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS) ; do
	touch ${DATA_DIR}${CLUSTER}/${NODE}
done
#
NODE_LIST=`find ${DATA_DIR}${CLUSTER} -type f ! -name SYSTEMS ! -name MESSAGE -print`
#       Check if ${NODE_LIST} is zero length
if [ -z "${NODE_LIST}" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:      No file(s) found\n" 1>&2
	echo -e "\tCheck to make sure user has permission to create directory and files."
	exit 1
fi
for NODE in ${NODE_LIST} ; do
#	Check if ${NODE##*/} is ${LOCALHOST} don't use ssh and scp
	if [ "${LOCALHOST}" != "${NODE##*/}" ] ; then
#	Check if ${NODE} is available on port ${SSHPORT}
		if $(nc -z ${NODE##*/} ${SSHPORT} >/dev/null) ; then
			TEMP="docker system info | head -5 > ${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE##*/} ${TEMP}
			TEMP="/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//'"
			CELSIUS=$(ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE##*/} ${TEMP})
			FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
			TEMP="echo 'Celsius: '${CELSIUS} >> ${NODE} ; echo 'Fahrenheit: '${FAHRENHEIT} >> ${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE##*/} ${TEMP}
			TEMP="uptime | sed -s 's/^.*:/System_Load:/' >> ${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${ADMUSER}@${NODE##*/} ${TEMP}
			scp -q    -i ~/.ssh/id_rsa -P ${SSHPORT} ${ADMUSER}@${NODE##*/}:${NODE} ${DATA_DIR}${CLUSTER}
		else
			echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:        ${NODE##*/} not responding on port ${SSHPORT}.\n"   1>&2
		fi
	else
		docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		CELSIUS=$(/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//')
		echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
		echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		UPTIME=$(uptime | sed -s 's/^.*:/System_Load:/')
		echo ${UPTIME} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
	fi
	CONTAINERS=`grep -i CONTAINERS ${NODE} | awk -v v=$CONTAINERS '{print $2 + v}'`
	RUNNING=`grep -i RUNNING ${NODE} | awk -v v=$RUNNING '{print $2 + v}'`
	PAUSED=`grep -i PAUSED ${NODE} | awk -v v=$PAUSED '{print $2 + v}'`
	STOPPED=`grep -i STOPPED ${NODE} | awk -v v=$STOPPED '{print $2 + v}'`
	IMAGES=`grep -i IMAGES ${NODE} | awk -v v=$IMAGES '{print $2 + v}'`
done
MESSAGE=" CONTAINERS ${CONTAINERS}  RUNNING ${RUNNING}  PAUSED ${PAUSED}  STOPPED ${STOPPED}  IMAGES ${IMAGES} "
echo ${MESSAGE} > ${DATA_DIR}${CLUSTER}/MESSAGE
#	echo    "${0} ${LINENO} -->${LOCALHOST}<--->${NODE##*/}<--->${SSHPORT}<--->${ADMUSER}<--"
#	echo    "${0} ${LINENO} -->${CONTAINERS}<--->${RUNNING}<--->${PAUSED}<---->${STOPPED}<---->${IMAGES}<----"
#	echo    "${0} ${LINENO} -->${LOCALHOST}<--n-->${NODE}<--dd-->${DATA_DIR}<--c-->${CLUSTER}<--P-->${SSHPORT}<--U-->${ADMUSER}<--"
#	echo ${MESSAGE} > ${DATA_DIR}${CLUSTER}/MESSAGE
###
