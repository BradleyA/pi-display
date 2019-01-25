#!/bin/bash
# 	create-message/create-host-info.sh  3.377.573  2019-01-25T11:08:48.994413-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.376  
# 	   create-message/create-host-info.sh --> production standard 5 include Copyright notice close #68 
# 	create-message/create-host-info.sh  3.319.505  2019-01-12T15:45:20.194322-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.318  
# 	   template.[sh,py] production standard 4 change display_help of other LANG 
# 	create-message/create-host-info.sh  3.317.503  2019-01-11T14:44:05.863831-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.316  
# 	   security: check log & script file and directory permissions close #55 
# 	create-message/local-create-message.sh  3.247.390  2018-12-29T22:08:55.633438-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.246  
# 	   local-create-message.sh Change log format and order close #60 
#
### create-host-info.sh
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#   production standard 5
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Create ${LOCALHOST} Docker and system information"
echo -e "\nUSAGE\n   ${0} [<CLUSTER>] [<DATA_DIR>] [<ADMUSER>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo   "This script stores Docker information and system information in a file,"
echo    "/usr/local/data/<CLUSTER>/<hostname>.  The Docker information includes the"
echo    "number of containers, running containers, paused containers, stopped"
echo    "containers, and number of images.  The system information includes cpu"
echo    "temperature in Celsius and Fahrenheit, the system load, memory usage, and"
echo    "disk usage.  The <hostname> file information is used by a Raspberry Pi"
echo    "with Pimoroni Blinkt to display the system information in near real time."
#       Displaying help DESCRIPTION in French
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>"
        echo    "Souhaitez-vous traduire la section description?"
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; export DEBUG='1' on the command line to set"
echo    "the DEBUG environment variable to '1'.  Use the command, unset DEBUG to remove"
echo    "the exported information from the DEBUG environment variable.  To set an"
echo    "environment variable to be defined at login, add it to ~/.bashrc file or you"
echo    "can modify this script with your default location for CLUSTER, DATA_DIR, and"
echo    "DEBUG.  You are on your own defining environment variables if you are using"
echo    "other shells."
echo    "   CLUSTER       (default us-tx-cluster-1/)"
echo    "   DATA_DIR      (default /usr/local/data/)"
echo    "   DEBUG         (default '0')"
echo -e "\nOPTIONS"
echo    "   CLUSTER       name of cluster directory, default us-tx-cluster-1"
echo    "   DATA_DIR      path to cluster data directory, default /usr/local/data/"
echo    "   ADMUSER       site SRE administrator, default is user running script"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display-board"
}

#       Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
TEMP=$(date +%Z)
DATE_STAMP="${DATE_STAMP} (${TEMP})"
}

#       Fully qualified domain name FQDN hostname
LOCALHOST=$(hostname -f)

#       Version
SCRIPT_NAME=$(head -2 "${0}" | awk {'printf $2'})
SCRIPT_VERSION=$(head -2 "${0}" | awk {'printf $3'})

#       UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
#	Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#	Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then DATA_DIR=${2} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#	Order of precedence: CLI argument, default code
ADMUSER=${3:-${USER}}
#
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  CLUSTER >${CLUSTER}< ADMUSER >${ADMUSER}< DATA_DIR >${DATA_DIR}< PATH >${PATH}<" 1>&2 ; fi

#	set admin user Docker environment variables (crontab support) in ~/.profile. #31
source ~/.profile
TEMP=`env | grep -i docker | sed -e 's/$/  /' | tr -d '\n'`
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Docker environment variables after source command >${TEMP}<" 1>&2 ; fi

#       Check if cluster directory is on system if not fix it
if [ ! -d ${DATA_DIR}/${CLUSTER}/log ] || [ ! -d ${DATA_DIR}/${CLUSTER}/logrotate ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Creating missing directories: ${DATA_DIR}/${CLUSTER}..." 1>&2
	mkdir -p  ${DATA_DIR}/${CLUSTER}/log || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADMUSER} does not have permission to create ${DATA_DIR}/${CLUSTER} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}/${CLUSTER}
	chmod 770 ${DATA_DIR}/${CLUSTER}/log
	mkdir -p  ${DATA_DIR}/${CLUSTER}/logrotate
	chmod 770 ${DATA_DIR}/${CLUSTER}/logrotate
fi

###
#	DOCKER
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Gather docker info on ${LOCALHOST}" 1>&2 ; fi
docker system info | head -6 > ${DATA_DIR}/${CLUSTER}/${LOCALHOST}

#	CELSIUS, FAHRENHEIT
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  CELSIUS, FAHRENHEIT from ${LOCALHOST}" 1>&2 ; fi
CELSIUS=$(/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//')
echo 'CELSIUS: '${CELSIUS} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
echo 'FAHRENHEIT: '${FAHRENHEIT} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}

#	CPU
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  CPU" 1>&2 ; fi
/usr/local/bin/CPU_usage.sh >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}

#	MEMORY
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  MEMORY" 1>&2 ; fi
MEMORY=$(free -m | grep -i Mem: | awk '{printf "MEMORY_USAGE: %sM  %d", $2,($2-$7)/$2*100}')
echo ${MEMORY} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}

#	DISK
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  DISK" 1>&2 ; fi
DISK=$(df -h | awk '$NF=="/"{printf "DISK_USAGE: %d/%dGB %d\n", $3,$2,$5}')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Update file ${DATA_DIR}/${CLUSTER}/${LOCALHOST}" 1>&2 ; fi
echo ${DISK} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
