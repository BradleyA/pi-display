#!/bin/bash
# 	create-message.sh  3.179.321  2018-09-30_18:31:50_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.178  
# 	   typo 
# 	create-message.sh  3.178.320  2018-09-30_18:27:26_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.177  
# 	   Change echo or print DEBUG INFO WARNING ERROR close #43 
### 
DEBUG=0                 # 0 = debug off, 1 = debug on
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Store Docker and system information"
echo -e "\nUSAGE\n   ${0} [<CLUSTER>] [<ADMUSER>] [<DATA_DIR>] [<MESSAGE_FILE>] [SYSTEMS_FILE]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nThis script stores Docker information and system information in a file,"
echo    "/usr/local/data/us-tx-cluster-1/<hostname>, on each system in SYSTEMS_FILE."
echo    "These <hostname> files are copied to a host and totaled in a file,"
echo    "/usr/local/data/us-tx-cluster-1/MESSAGE and MESSAGEHD.  The MESSAGE files"
echo    "includes the total number of containers, running containers, paused containers,"
echo    "stopped containers, and number of images.  The MESSAGE files are used by a"
echo    "Raspberry Pi with Pimoroni Scroll-pHAT or Pimoroni Scroll-pHAT-HD to display"
echo    "the information.  The <hostname> file on each system is used by a Raspberry Pi"
echo    "with a Pimoroni blinkt."
echo -e "\nThis script reads /usr/local/data/us-tx-cluster-1/SYSTEMS file for hosts."
echo    "The hosts are one FQDN or IP address per line for all hosts in a cluster."
echo    "Lines in SYSTEMS file that begin with a # are comments.  The SYSTEMS file is"
echo    "used by Linux-admin/cluster-command/cluster-command.sh, markit/find-code.sh,"
echo    "pi-display/create-message/create-message.sh, and other scripts.  A different"
echo    "SYSTEMS file can be entered on the command line or environment variable."
echo -e "\nSystem inforamtion about each host is stored in"
echo    "/usr/local/data/us-tx-cluster-1/<hostname>.  The system information includes"
echo    "cpu temperature in Celsius and Fahrenheit, the system load, memory usage, and"
echo    "disk usage.  The system information will be used by blinkt to display system"
echo    "information about each system in near real time."
echo -e "\nTo avoid many login prompts for each host in a cluster, enter the following:"
echo    "${BOLD}ssh-copy-id uadmin@<host-name>${NORMAL} to each host in the SYSTEMS file."
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; export CLUSTER='us-west1' on the command"
echo    "line to set the CLUSTER environment variable to 'us-west1'.  Use the command,"
echo    "unset CLUSTER to remove the exported information from the CLUSTER environment"
echo    "variable.  To set an environment variable to be defined at login, add it to"
echo    "~/.bashrc file or you can modify this script with your default location for"
echo    "CLUSTER, DATA_DIR, MESSAGE_FILE, and SYSTEMS_FILE.  You are on your own"
echo    "defining environment variables if you are using other shells."
echo    "   CLUSTER       (default us-tx-cluster-1/)"
echo    "   DATA_DIR      (default /usr/local/data/)"
echo    "   MESSAGE_FILE  (default MESSAGE)"
echo    "   SYSTEMS_FILE  (default SYSTEMS)"
echo -e "\nOPTIONS"
echo    "   CLUSTER       name of cluster directory, default us-tx-cluster-1"
echo    "   ADMUSER       site SRE administrator, default is user running script"
echo    "   DATA_DIR      path to cluster data directory, default /usr/local/data/"
echo    "   MESSAGE_FILE  name of MESSAGE file, default MESSAGE and MESSAGEHD"
echo    "   SYSTEMS_FILE  name of SYSTEMS file, (default SYSTEMS)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display-board"
echo -e "\nEXAMPLES"
echo -e "   Store message information for a cluster-2\n\n   ${0} cluster-2\n"
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported, Would you like to help translate?" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported.\tWould you like to translate?" 1>&2
fi
}

#       Date and time function
get_date_stamp() {
DATE_STAMP=`date +%Y-%m-%d-%H-%M-%S-%Z`
}

#  Fully qualified domain name FQDN hostname
LOCALHOST=`hostname -f`

#  Version
SCRIPT_NAME=`head -2 ${0} | awk {'printf$2'}`
SCRIPT_VERSION=`head -2 ${0} | awk {'printf$3'}`

#       UID and GID
USER_ID=`id -u`
GROUP_ID=`id -g`

#	Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
	echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       DEBUG example
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Name_of_command >${0}< Name_of_arg1 >${1}<" 1>&2 ; fi

#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#	order of precedence: CLI argument, default code
ADMUSER=${2:-${USER}}
#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then DATA_DIR=${3} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  4 ]  ; then MESSAGE_FILE=${4} ; elif [ "${MESSAGE_FILE}" == "" ] ; then MESSAGE_FILE="MESSAGE" ; fi
#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  5 ]  ; then SYSTEMS_FILE=${5} ; elif [ "${SYSTEMS_FILE}" == "" ] ; then SYSTEMS_FILE="SYSTEMS" ; fi
#
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CLUSTER >${CLUSTER}< ADMUSER >${ADMUSER}< DATA_DIR >${DATA_DIR}< MESSAGE_FILE >${MESSAGE_FILE}< SYSTEMS_FILE >${SYSTEMS_FILE}< PATH >${PATH}<" 1>&2 ; fi

#
CONTAINERS=0
RUNNING=0
PAUSED=0
STOPPED=0
IMAGES=0

#	set admin user Docker environment variables (crontab support) in ~/.profile. #31
source ~/.profile
TEMP=`env | grep -i docker`
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Docker environment variables after source command >${TEMP}<" 1>&2 ; fi

#       Check if cluster directory is on system
if [ ! -d ${DATA_DIR}/${CLUSTER} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Creating missing directory: ${DATA_DIR}/${CLUSTER}" 1>&2
	mkdir -p  ${DATA_DIR}/${CLUSTER} || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  User ${ADMUSER} does not have permission to create ${DATA_DIR}/${CLUSTER} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}/${CLUSTER}
fi

#	Create ${MESSAGE_FILE} file 1) create file for initial running on host, 2) check for write permission
touch ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  User ${ADMUSER} does not have permission to create ${MESSAGE_FILE} file" 1>&2 ; exit 1; }
touch ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}HD  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  User ${ADMUSER} does not have permission to create ${MESSAGE_FILE}HD file" 1>&2 ; exit 1; }

#       Check if ${SYSTEMS_FILE} file is on system, one FQDN or IP address per line for all hosts in cluster
if ! [ -e ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} ] || ! [ -s ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${SYSTEMS_FILE} file missing or empty, creating ${SYSTEMS_FILE} file with local host.  Edit ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file and add additional hosts that are in the cluster." 1>&2
	echo -e "###     List of hosts used by cluster-command.sh & create-message.sh"  > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
	echo -e "#       One FQDN or IP address per line for all hosts in cluster" > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
	echo -e "###" > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
	hostname -f > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
fi

#	Loop through hosts in ${SYSTEMS_FILE} file
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Loop through hosts in ${SYSTEMS_FILE} file" 1>&2 ; fi
for NODE in $(cat ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} | grep -v "#" ); do
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  host >${NODE}<" 1>&2
#	Check if ${NODE} is ${LOCALHOST} don't use ssh and scp
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on ssh port 
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${LOCALHOST} != ${NODE}" 1>&2 ; fi
		if $(ssh ${NODE} 'exit' >/dev/null 2>&1 ) ; then
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Make directory and gather docker info on ${NODE}" 1>&2 ; fi
			TEMP="mkdir -p  ${DATA_DIR}/${CLUSTER} ; chmod 775 ${DATA_DIR}/${CLUSTER} ; docker system info | head -5 > ${DATA_DIR}/${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CELSIUS, FAHRENHEIT from ${NODE}" 1>&2 ; fi
			TEMP="/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//'"
			CELSIUS=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP})
			FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
			TEMP="echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}/${CLUSTER}/${NODE} ; echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}/${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CPU" 1>&2 ; fi
			scp -q    -i ~/.ssh/id_rsa /usr/local/bin/CPU_usage.sh ${ADMUSER}@${NODE}:/usr/local/bin/
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} "/usr/local/bin/CPU_usage.sh >> ${DATA_DIR}/${CLUSTER}/${NODE}"
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  MEMORY" 1>&2 ; fi
			MEMORY=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'free -m | grep Mem:')
			MEMORY=$(echo ${MEMORY} | awk '{printf "Memory_Usage: %s/%sMB %d", $3,$2,$3*100/$2 }')
			MEMORY2=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'vcgencmd get_mem arm')
			MEMORY2=$(echo ${MEMORY2} | sed 's/=/: /' | awk '{printf ".Memory_%s", $1" "$2 }')
			MEMORY3=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'vcgencmd get_mem gpu')
			MEMORY3=$(echo ${MEMORY3} | sed 's/=/: /' | awk '{printf ".Memory_%s", $1" "$2 }')
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  MEMORY >${MEMORY}<" 1>&2 ; fi
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  MEMORY2 >${MEMORY2}<<" 1>&2 ; fi
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  MEMORY3 >${MEMORY3}<<<" 1>&2 ; fi
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  DISK" 1>&2 ; fi
			DISK=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'df -h  | grep -m 1 "^/"')
			DISK=$(echo ${DISK} | awk '{printf "Disk_Usage: %d/%dGB %d\n", $3,$2,$5}')
			TEMP="echo ${MEMORY} >> ${DATA_DIR}/${CLUSTER}/${NODE} ; echo ${MEMORY2} >> ${DATA_DIR}/${CLUSTER}/${NODE} ; echo ${MEMORY3} >> ${DATA_DIR}/${CLUSTER}/${NODE} ; echo ${DISK} >> ${DATA_DIR}/${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Copy ${NODE} information to ${LOCALHOST}" 1>&2 ; fi
			scp -q    -i ~/.ssh/id_rsa ${ADMUSER}@${NODE}:${DATA_DIR}/${CLUSTER}/${NODE} ${DATA_DIR}/${CLUSTER}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Copy ${SYSTEMS_FILE} file from ${LOCALHOST} to ${NODE}" 1>&2 ; fi
			scp -q    -i ~/.ssh/id_rsa ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} ${ADMUSER}@${NODE}:${DATA_DIR}/${CLUSTER}
		else
			get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${NODE} found in ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file is not responding to ${LOCALHOST} on ssh port." 1>&2
			touch ${DATA_DIR}/${CLUSTER}/${NODE}
		fi
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  - Cluster Server" 1>&2
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Gather docker info on ${NODE}" 1>&2 ; fi
		docker system info | head -5 > ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CELSIUS, FAHRENHEIT from ${NODE}" 1>&2 ; fi
		CELSIUS=$(/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//')
		echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
		echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CPU" 1>&2 ; fi
		/usr/local/bin/CPU_usage.sh >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  MEMORY" 1>&2 ; fi
		MEMORY=$(free -m | awk 'NR==2{printf "Memory_Usage: %s/%sMB %d\n", $3,$2,$3*100/$2 }')
		echo ${MEMORY} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		MEMORY2=$(vcgencmd get_mem arm | sed 's/=/: /' | awk '{printf ".Memory_%s\n", $1" "$2 }')
		echo ${MEMORY2} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		MEMORY3=$(vcgencmd get_mem gpu | sed 's/=/: /' | awk '{printf ".Memory_%s\n", $1" "$2 }')
		echo ${MEMORY3} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  DISK" 1>&2 ; fi
		DISK=$(df -h | awk '$NF=="/"{printf "Disk_Usage: %d/%dGB %d\n", $3,$2,$5}')
		echo ${DISK} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
		cd ${DATA_DIR}/${CLUSTER}
		#       Check if LOCAL-HOST file is on system
		if [ -e LOCAL-HOST ] ; then rm LOCAL-HOST ; fi	# bad bug fix #26
	fi
	CONTAINERS=`grep -i CONTAINERS ${DATA_DIR}/${CLUSTER}/${NODE} | awk -v v=$CONTAINERS '{print $2 + v}'`
	RUNNING=`grep -i RUNNING ${DATA_DIR}/${CLUSTER}/${NODE} | awk -v v=$RUNNING '{print $2 + v}'`
	PAUSED=`grep -i PAUSED ${DATA_DIR}/${CLUSTER}/${NODE} | awk -v v=$PAUSED '{print $2 + v}'`
	STOPPED=`grep -i STOPPED ${DATA_DIR}/${CLUSTER}/${NODE} | awk -v v=$STOPPED '{print $2 + v}'`
	IMAGES=`grep -i IMAGES ${DATA_DIR}/${CLUSTER}/${NODE} | awk -v v=$IMAGES '{print $2 + v}'`
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Add Docker information from ${NODE}" 1>&2 ; fi
done
MESSAGE=" CONTAINERS ${CONTAINERS}  RUNNING ${RUNNING}  PAUSED ${PAUSED}  STOPPED ${STOPPED}  IMAGES ${IMAGES}"
echo ${MESSAGE} > ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}
cp ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE} ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}HD
tail -n +6 ${DATA_DIR}/${CLUSTER}/${LOCALHOST} >> ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}HD

#	Loop through hosts in ${SYSTEMS_FILE} file and update other host information
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Loop through hosts in ${SYSTEMS_FILE} file and update other host information" 1>&2 ; fi
for NODE in $(cat ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} | grep -v "#" ); do
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Copy file to host ${NODE}" 1>&2
#	Check if ${NODE} is ${LOCALHOST} skip already did before the loop
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on ssh port
		if $(ssh ${NODE} 'exit' >/dev/null 2>&1 ) ; then
			scp -q    -i ~/.ssh/id_rsa ${DATA_DIR}/${CLUSTER}/* ${ADMUSER}@${NODE}:${DATA_DIR}/${CLUSTER}
			TEMP="cd ${DATA_DIR}/${CLUSTER} ; ln -sf ${NODE} LOCAL-HOST"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
		else
			get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${NODE} found in ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file is not responding to ${LOCALHOST} on ssh port." 1>&2
		fi
	fi
done
ln -sf ${LOCALHOST} LOCAL-HOST	# bug fix #26
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Done." 1>&2
###
