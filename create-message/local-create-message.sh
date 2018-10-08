#!/bin/bash
# 	local-create-message.sh  3.196.338  2018-10-07T20:01:40-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.195  
# 	   first draft of : local-create-message.sh to be run locally on each systemin cluster #37 
### 
DEBUG=0                 # 0 = debug off, 1 = debug on
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
###
display_help() {
echo -e "\n${NORMAL}${0} - >>> NEED TO COMPLETE THIS SOON, ONCE I KNOW HOW IT IS GOING TO WORK :-) <<<"
echo -e "\nUSAGE\n   ${0}"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nXXXXXX "
echo -e "\nOPTIONS "
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-scripts/tree/master/cpu-temperature"
echo -e "\nEXAMPLES\n   XXXXXX \n\t${0} XXXXXX\n"
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

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Begin"  1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Name_of_command >${0}< Name_of_arg1 >${1}<" 1>&2 ; fi

#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#	order of precedence: CLI argument, default code
ADMUSER=${2:-${USER}}
#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then DATA_DIR=${3} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CLUSTER >${CLUSTER}< ADMUSER >${ADMUSER}< DATA_DIR >${DATA_DIR}< PATH >${PATH}<" 1>&2 ; fi

#	set admin user Docker environment variables (crontab support) in ~/.profile. #31
source ~/.profile
TEMP=`env | grep -i docker | sed -e 's/$/  /' | tr -d '\n'`
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Docker environment variables after source command >${TEMP}<" 1>&2 ; fi

#       Check if cluster directory is on system if not fix it
if [ ! -d ${DATA_DIR}/${CLUSTER} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Creating missing directory: ${DATA_DIR}/${CLUSTER}" 1>&2
	mkdir -p  ${DATA_DIR}/${CLUSTER} || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  User ${ADMUSER} does not have permission to create ${DATA_DIR}/${CLUSTER} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}/${CLUSTER}
fi

###
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Gather docker info on ${LOCALHOST}" 1>&2 ; fi
docker system info | head -6 > ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CELSIUS, FAHRENHEIT from ${LOCALHOST}" 1>&2 ; fi
CELSIUS=$(/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//')
echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
#	
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  CPU" 1>&2 ; fi
/usr/local/bin/CPU_usage.sh >> ${DATA_DIR}/${CLUSTER}/${LOCALHOST}
#	
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

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Done." 1>&2
###
