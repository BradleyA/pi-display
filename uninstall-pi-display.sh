#!/bin/bash
# 	uninstall-pi-display.sh  3.358.544  2019-01-18T20:13:28.655005-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.357  
# 	   incident 104 
# 	uninstall-pi-display.sh  3.357.543  2019-01-18T20:09:24.032761-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.356  
# 	   set command in bash to debug 
# 	uninstall-pi-display.sh  3.356.542  2019-01-18T20:08:08.009307-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.355  
# 	   testing 
# 	uninstall-pi-display.sh  3.355.541  2019-01-18T19:59:15.832984-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.354  
# 	   command not found 98 
# 	uninstall-pi-display.sh  3.354.540  2019-01-18T17:24:03.296278-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.353  
# 	   testing 
# 	uninstall-pi-display.sh  3.353.539  2019-01-18T17:21:26.000945-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.352  
# 	   try ${USER} 
# 	uninstall-pi-display.sh  3.352.538  2019-01-18T17:08:36.567300-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.351  
# 	   changes to default user and group when not enter on command line 
#
### uninstall-pi-display.sh
#   production standard 4
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="1" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - uninstall pi-display"
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [<CLUSTER>] [<DATA_DIR>] [<ADMUSER>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "This script has to be run as root to uninstall /<DATA_DIR>/<CLUSTER>.  The"
echo    "commands will be uninstalled from /usr/local/bin and the logs from"
echo    "/<DATA_DIR>/<CLUSTER> directory.  The /<DATA_DIR>/<CLUSTER>/SYSTEMS file"
echo    "will not be removed because the SYSTEMS file is also used by"
echo    "Linux-admin/cluster-command/cluster-command.sh, markit/find-code.sh,"
echo    "pi-display/create-message/create-display-message.sh, and other scripts."
#       Displaying help DESCRIPTION in French
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nOPTIONS"
echo    "   CLUSTER         name of cluster directory, default us-tx-cluster-1"
echo    "   DATA_DIR        path to cluster data directory, default /usr/local/data/"
echo    "   ADMUSER         site SRE administrator, default is user running script"
echo -e "\nDOCUMENTATION\n    https://github.com/BradleyA/pi-display-board"
echo -e "\nEXAMPLES\n   sudo ${0}\n"
echo -e "   sudo ${0} us-tx-cluster-1 /usr/local/data\n"
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
if ! [ "$(id -u)" = 0 ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
	echo -e "\n>>   ${BOLD}SCRIPT MUST BE RUN AS ROOT${NORMAL} <<"  1>&2
        exit 1
fi

#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then DATA_DIR=${2} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#       Order of precedence: CLI argument
set -x
if [ $# -ge  3 ]  ; then ADMUSER=${3} ; else "${ADMUSER}" == "${USER}" 
	echo -e "\n\t${BOLD}Warning:  ${ADMUSER} crontab will be removed . . ."
fi
set +x
#
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}< ADMUSER >${ADMUSER}<" 1>&2 ; fi

###	Remove instructions from ${ADMUSER} crontab
if [ -e /var/spool/cron/crontabs/"${ADMUSER}" ] ; then
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Remove ${DATA_DIR}/${CLUSTER}/logrotate/*${LOCALHOST}-crontab" 1>&2 ; fi
	DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
	echo -e "\n\tRemoving content from /var/spool/cron/crontabs/${ADMUSER}" 1>&2
	echo -e "\tA backup copy of this file can be found, /var/spool/cron/crontabs/${ADMUSER}.${DATE_STAMP}" 1>&2
	echo -e "\tCheck copy of file can be found, /var/spool/cron/crontabs/${ADMUSER}.${DATE_STAMP}" 1>&2
	echo -e "\n\t${BOLD}Edit /var/spool/cron/crontabs/${ADMUSER} using crontab -e" 1>&2
	cp /var/spool/cron/crontabs/"${ADMUSER}" /var/spool/cron/crontabs/"${ADMUSER}"."${DATE_STAMP}"
	head -n 3 /var/spool/cron/crontabs/"${ADMUSER}"."${DATE_STAMP}" >  /var/spool/cron/crontabs/"${ADMUSER}"
fi

#   Remove scripts and files
rm /usr/local/bin/display-led.py
rm /usr/local/bin/display-led-test.py
rm /usr/local/bin/CPU_usage.sh
rm /usr/local/bin/create-display-message.sh
rm /usr/local/bin/create-host-info.sh
rm /usr/local/bin/display-message.py
rm /usr/local/bin/display-scrollphat-test.py
rm /usr/local/bin/display-message-hd.py
rm /usr/local/bin/display-scrollphathd-test.py
#
rm ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
#
if [ -e "${DATA_DIR}"/"${CLUSTER}"/logrotate/EXT ] ; then
	rm ${DATA_DIR}/${CLUSTER}/logrotate/EXT
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Remove ${DATA_DIR}/${CLUSTER}/logrotate/EXT" 1>&2 ; fi
fi
#
if [ -e ${DATA_DIR}/${CLUSTER}/logrotate/*"${LOCALHOST}"-crontab ] ; then
	rm ${DATA_DIR}/${CLUSTER}/logrotate/*"${LOCALHOST}"-crontab
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Remove ${DATA_DIR}/${CLUSTER}/logrotate/*${LOCALHOST}-crontab" 1>&2 ; fi
fi
#
if [ -e ${DATA_DIR}/${CLUSTER}/log/"${LOCALHOST}"-crontab ] ; then
	rm ${DATA_DIR}/${CLUSTER}/log/"${LOCALHOST}"-crontab
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Remove ${DATA_DIR}/${CLUSTER}/log/${LOCALHOST}-crontab" 1>&2 ; fi
fi

###	Remove git clone
cd ..
#       Check if directory 
echo    ">>>> STOP    STOP   STOP    <<<  uncomment next line when DONE"
if [ -d ./pi-display ] ; then
	echo -e "\t${BOLD}Remove directory ./pi-display/"
#        rm -rf ./pi-display/
else
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  ./pi-display/ not found"  1>&2
fi

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
