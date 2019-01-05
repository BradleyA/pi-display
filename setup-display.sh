#!/bin/bash
# 	setup-display.sh  3.278.452  2019-01-05T11:51:43.569303-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.277  
# 	   second draft 
# 	setup-display.sh  3.276.450  2019-01-05T08:48:46.134134-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.275  
# 	   updated display_help 
# 	setup-display.sh  3.274.448  2019-01-04T13:34:08.562046-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.273-11-gf99f687  
# 	   update display_help 
# 	setup-display.sh  3.269.428  2019-01-03T14:42:35.499629-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.268  
# 	   start creating setup for pi-display 
#
### setup-display.sh
#   production standard 3
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - setup system to gathering and display Docker & System info"
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [<CLUSTER>] [<DATA_DIR>] [<ADMUSER>] [ADMGRP]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nThis script has to be run as root to create /usr/local/data/<CLUSTER>.  The"
echo    "commands are installed in /usr/local/bin and will store logs, Docker and"
echo    "system information into /usr/local/data/<CLUSTER> directory.  The Docker"
echo    "information includes the number of containers, running containers, paused"
echo    "containers, stopped containers, and number of images.  The system information"
echo    "includes cpu temperature in Celsius and Fahrenheit, the system load, memory"
echo    "usage, and disk usage."
echo -e "The information in /usr/local/data/<CLUSTER>/<hostname> file is created by"
echo    "create-host-info.sh and can be used by display-led.py for Raspberry Pi with"
echo    "Pimoroni Blinkt to display the system information in near real time.  It is"
echo    "also used by create-display-message.sh.  The <hostname> files are copied to"
echo    "each host found in /usr/local/data/<CLUSTER>/SYSTEMS and totaled in a file,"
echo    "/usr/local/data/<CLUSTER>/MESSAGE and MESSAGEHD.  The MESSAGE files include"
echo    "the total number of containers, running containers, paused containers,"
echo    "stopped containers, and number of images.  The MESSAGE files are used by a"
echo    "Raspberry Pi with Pimoroni Scroll-pHAT or Pimoroni Scroll-pHAT-HD to"
echo    "display the information."
echo -e "\nThis script reads /usr/local/data/<CLUSTER>/SYSTEMS file for hosts."
echo    "The hosts are one FQDN or IP address per line for all hosts in a cluster."
echo    "Lines in SYSTEMS file that begin with a # are comments.  The SYSTEMS file is"
echo    "used by Linux-admin/cluster-command/cluster-command.sh, markit/find-code.sh,"
echo    "pi-display/create-message/create-display-message.sh, and other scripts."
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  To set an environment variable to be defined at login,"
echo    "add it to ~/.bashrc file or you can modify this script with your default"
echo    "location.  You are on your own defining environment variables if you are"
echo    "using other shells."
echo    "   CLUSTER       (default us-tx-cluster-1/)"
echo    "   DATA_DIR      (default /usr/local/data/)"
echo    "   DEBUG         (default '0')"
echo -e "\nOPTIONS"
echo    "   CLUSTER       name of cluster directory, default us-tx-cluster-1"
echo    "   DATA_DIR      path to cluster data directory, default /usr/local/data/"
echo    "   ADMUSER       site SRE administrator, default is user running script"
echo    "   ADMGRP        site SRE group, default is group running script"
echo -e "\nDOCUMENTATION\n    https://github.com/BradleyA/pi-display-board"
echo -e "\nEXAMPLES\n   sudo ${0}\n"
echo -e "   sudo ${0} us-tx-cluster-1 /usr/local/data uadmin uadmin\n"
#       After displaying help in english check for other languages
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  ${LANG}, is not supported, Would you like to help translate?" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate?" 1>&2
fi
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
#       Must be root to run this script
#	if ! [ $(id -u) = 0 ] ; then
        #	display_help | more
        #	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
        #	echo -e "\n>>   ${BOLD}SCRIPT MUST BE RUN AS ROOT${NORMAL} <<"  1>&2
        #	exit 1
#	fi

#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then DATA_DIR=${3} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#       Order of precedence: CLI argument, default code
ADMUSER=${3:-$(id -u)}
#       Order of precedence: CLI argument, default code
ADMGRP=${4:-$(id -g)}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}< ADMUSER >${ADMUSER}< ADMGRP >${ADMGRP}<" 1>&2 ; fi

#
mkdir -p /usr/local/bin
mkdir -p /usr/local/data/$(CLUSTER)/log
mkdir -p /usr/local/data/$(CLUSTER)/logrotate
#
chmod 0775 /usr/local/bin
chmod 0775 /usr/local/data
chmod 0775 /usr/local/data/$(CLUSTER)
chmod 0775 /usr/local/data/$(CLUSTER)/log
chmod 0775 /usr/local/data/$(CLUSTER)/logrotate
#
chown    ${ADMUSER}:${ADMGRP} /usr/local/bin
chown -R ${ADMUSER}:${ADMGRP} /usr/local/data
#
mv pi-display                                 /usr/local/data/$(CLUSTER)/logrotate
mv blinkt/display-led.py                      /usr/local/bin
mv blinkt/display-led-test.py                 /usr/local/bin
mv create-message/CPU_usage.sh                /usr/local/bin
mv create-message/create-display-message.sh   /usr/local/bin
mv create-message/create-host-info.sh         /usr/local/bin
mv scrollphat/display-message.py              /usr/local/bin
mv scrollphat/display-scrollphat-test.py      /usr/local/bin
mv scrollphathd/display-message-hd.py         /usr/local/bin
mv scrollphathd/display-scrollphathd-test.py  /usr/local/bin

#       Check if SYSTEMS file on system
if ! [ -e ${DATA_DIR}/${CLUSTER}/SYSTEMS ] ; then
        echo -e "\t${DATA_DIR}/${CLUSTER}/SYSTEMS file not found."
	echo -e "\tCreating ${NORMAL}${DATA_DIR}/${CLUSTER}/SYSTEMS file with local host."
        echo -e "\tEdit ${NORMAL}${DATA_DIR}/${CLUSTER}/SYSTEMS to additional hosts."
	echo "###     List of hosts used by cluster-command.sh, create-display-message.sh, etc." > ${DATA_DIR}/${CLUSTER}/SYSTEMS
        echo "###" >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
        echo "#       One FQDN host on each line" >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
        echo "###" >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
        $(hostname -f) >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
fi

crontab

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
