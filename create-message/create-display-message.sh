#!/bin/bash
# 	create-message/create-display-message.sh  3.403.631  2019-08-09T13:50:45.279479-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  one-rpi3b.cptx86.com 3.402-2-g700767e  
# 	   create-message/create-display-message.sh change WARN to ERROR #73 
# 	create-message/create-display-message.sh  3.402.628  2019-05-05T23:44:27.278222-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  one-rpi3b.cptx86.com 3.401  
# 	   #73 debug addition with "" 
#
### create-message/create-display-message.sh
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#   production standard 5
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="1" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Store Docker and system information"
echo -e "\nUSAGE\n   ${0} [<CLUSTER>] [<ADMUSER>] [<DATA_DIR>] [<MESSAGE_FILE>] [<SYSTEMS_FILE>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "This script stores Docker information and system information in a file,"
echo    "<DATA_DIR>/<CLUSTER>/<hostname>, on each system in <SYSTEMS_FILE>."
echo    "These <hostname> files are copied to a host and totaled in a file,"
echo    "<DATA_DIR>/<CLUSTER>/MESSAGE and MESSAGEHD.  The MESSAGE files"
echo    "includes the total number of containers, running containers, paused containers,"
echo    "stopped containers, and number of images.  The MESSAGE files are used by a"
echo    "Raspberry Pi with Pimoroni Scroll-pHAT or Pimoroni Scroll-pHAT-HD to display"
echo    "the information.  The <hostname> file on each system is used by a Raspberry Pi"
echo    "with a Pimoroni blinkt."
echo -e "\nThe <DATA_DIR>/<CLUSTER>/<SYSTEMS_FILE> includes one FQDN or IP address per"
echo    "line for all hosts in the cluster.  Lines in <SYSTEMS_FILE> that begin with a"
echo    "'#' are comments.  The <SYSTEMS_FILE> is used by markit/find-code.sh,"
echo    "Linux-admin/cluster-command/cluster-command.sh," 
echo    "pi-display/create-message/create-display-message.sh, and other scripts.  A"
echo    "different <SYSTEMS_FILE> can be entered on the command line or environment"
echo    "variable."
echo -e "\nSystem inforamtion about each host is stored in"
echo    "<DATA_DIR>/<CLUSTER>/<hostname>.  The system information includes"
echo    "cpu temperature in Celsius and Fahrenheit, the system load, memory usage, and"
echo    "disk usage.  The system information will be used by blinkt to display system"
echo    "information about each system in near real time."
echo -e "\nTo avoid many login prompts for each host in a cluster, enter the following:"
echo    "${BOLD}ssh-copy-id uadmin@<host-name>${NORMAL} to each host in the SYSTEMS file."
#       Displaying help DESCRIPTION in French
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>"
        echo    "Souhaitez-vous traduire la section description?"
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; export CLUSTER='us-west1' on the command"
echo    "line to set the CLUSTER environment variable to 'us-west1'.  Use the command,"
echo    "unset CLUSTER to remove the exported information from the CLUSTER environment"
echo    "variable.  To set an environment variable to be defined at login, add it to"
echo    "~/.bashrc file or you can modify this script with your default location for"
echo    "CLUSTER, DATA_DIR, MESSAGE_FILE, SYSTEMS_FILE, and DEBUG.  You are on your own"
echo    "own defining environment variables if you are using other shells."
echo    "   CLUSTER       (default us-tx-cluster-1/)"
echo    "   DATA_DIR      (default /usr/local/data/)"
echo    "   MESSAGE_FILE  (default MESSAGE)"
echo    "   SYSTEMS_FILE  (default SYSTEMS)"
echo    "   DEBUG         (default '0')"
echo -e "\nOPTIONS"
echo    "   CLUSTER       name of cluster directory, default us-tx-cluster-1"
echo    "   ADMUSER       site SRE administrator, default is user running script"
echo    "   DATA_DIR      path to cluster data directory, default /usr/local/data/"
echo    "   MESSAGE_FILE  name of MESSAGE file, default MESSAGE and MESSAGEHD"
echo    "   SYSTEMS_FILE  name of SYSTEMS file, (default SYSTEMS)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display-board"
echo -e "\nEXAMPLES"
echo -e "   Store message information for a cluster-2\n\n   ${0} cluster-2\n"
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

#	Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}   Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

#	Order of precedence: CLI argument, environment variable, default code
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
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  CLUSTER >${CLUSTER}< ADMUSER >${ADMUSER}< DATA_DIR >${DATA_DIR}< MESSAGE_FILE >${MESSAGE_FILE}< SYSTEMS_FILE >${SYSTEMS_FILE}< PATH >${PATH}<" 1>&2 ; fi

#	Set variables to zero before counting in loop 
CONTAINERS=0
RUNNING=0
PAUSED=0
STOPPED=0
IMAGES=0

#	Set admin user Docker environment variables (crontab support) in ~/.profile. #31
source ~/.profile
TEMP=$(env | grep -i docker)
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Docker environment variables after source command >${TEMP}<" 1>&2 ; fi

#       Check if data directory is on system
if [ ! -d "${DATA_DIR}"/"${CLUSTER}"/log ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Creating missing directory: ${DATA_DIR}" 1>&2
	mkdir -p  ${DATA_DIR} || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADMUSER} does not have permission to create ${DATA_DIR} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}
fi

#       Check if cluster directory is on system
if [ ! -d "${DATA_DIR}"/"${CLUSTER}"/log ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Creating missing directory: ${DATA_DIR}/${CLUSTER}" 1>&2
	mkdir -p  ${DATA_DIR}/${CLUSTER}/log || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADMUSER} does not have permission to create ${DATA_DIR}/${CLUSTER} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}/${CLUSTER}
	chmod 770 ${DATA_DIR}/${CLUSTER}/log
	mkdir -p  ${DATA_DIR}/${CLUSTER}/logrotate
	chmod 770 ${DATA_DIR}/${CLUSTER}/logrotate
fi

#	Create ${MESSAGE_FILE} file 1) create file for initial running on host, 2) check for write permission
touch ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADMUSER} does not have permission to create ${MESSAGE_FILE} file" 1>&2 ; exit 1; }
touch ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}HD  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADMUSER} does not have permission to create ${MESSAGE_FILE}HD file" 1>&2 ; exit 1; }

#       Check if ${SYSTEMS_FILE} file is on system, one FQDN or IP address per line for all hosts in cluster
if ! [ -e ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} ] || ! [ -s ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  ${SYSTEMS_FILE} file missing or empty, creating ${SYSTEMS_FILE} file with local host.  Edit ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file and add additional hosts that are in the cluster." 1>&2
	echo -e "###     List of hosts used by cluster-command.sh & create-message.sh"  > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
	echo -e "#       One FQDN or IP address per line for all hosts in cluster" > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
	echo -e "###" > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
	hostname -f > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
fi

#	Loop through hosts in ${SYSTEMS_FILE} file
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Loop through hosts in ${SYSTEMS_FILE} file" 1>&2 ; fi
for NODE in $(cat ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} | grep -v "#" ); do
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  --> Host >${NODE}<" 1>&2 ; fi
#	Check if ${NODE} is ${LOCALHOST} don't use ssh and scp
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#		Check if ${NODE} is available on ssh port 
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      ${LOCALHOST} != ${NODE}" 1>&2 ; fi
		if $(ssh ${NODE} 'exit' >/dev/null 2>&1 ) ; then
#			Copy ${NODE} information to ${LOCALHOST}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      Copy ${NODE} information to ${LOCALHOST}" 1>&2 ; fi
			scp -q    -i ~/.ssh/id_rsa ${ADMUSER}@${NODE}:${DATA_DIR}/${CLUSTER}/${NODE} ${DATA_DIR}/${CLUSTER} &
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      Finished: Copy ${NODE} information to ${LOCALHOST}" 1>&2 ; fi
		else
			get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${NODE} found in ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file is not responding to ${LOCALHOST}." 1>&2
			touch "${DATA_DIR}"/"${CLUSTER}"/"${NODE}"
		fi
	else
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      --> Cluster Server ${LOCALHOST}" 1>&2 ; fi
		cd ${DATA_DIR}/${CLUSTER}
#		Check if LOCAL-HOST file is on system
		if [ -e LOCAL-HOST ] ; then rm LOCAL-HOST ; fi	# very difficult to locate and solve bug fix #26
	fi
#	Check if NODE file is empty, try again #72
	if [ ! -s "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File ${DATA_DIR}/${CLUSTER}/${NODE} is empty.  Copy again.  Incidnet, why is file empty when being copied?" 1>&2
		sleep 1
		scp -q    -i ~/.ssh/id_rsa ${ADMUSER}@${NODE}:${DATA_DIR}/${CLUSTER}/${NODE} ${DATA_DIR}/${CLUSTER} &
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Copy ${NODE} information to ${LOCALHOST}" 1>&2 ; fi
	fi
# >>>	###  #73
# >>>	### Need to open a ticket becasue if a host does not have any CONTAINERS (or any of the other varaibles 
# >>>   ### 	being added below) the total is set to '' or /dev/null creating a false total value
# >>>	###
	TEMP=$(grep -i CONTAINERS "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk '{print $2}')
	if [ -z "${TEMP}" ] ; then TEMP=0 ; fi
#	CONTAINERS=$(grep -i CONTAINERS "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk -v v=$CONTAINERS '{print ($2 == "" ? "0" : $2) + v}')
	CONTAINERS=$(( ${CONTAINERS} + ${TEMP} ))
	TEMP=$(grep -i RUNNING "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk '{print $2}')
	if [ -z "${TEMP}" ] ; then TEMP=0 ; fi
#	RUNNING=$(grep -i RUNNING "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk '{print $2}' | awk -v v=$RUNNING '{print $1 + v}')
	RUNNING=$(( ${RUNNING} + ${TEMP} ))
	TEMP=$(grep -i PAUSED "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk '{print $2}')
	if [ -z "${TEMP}" ] ; then TEMP=0 ; fi
#	PAUSED=$(grep -i PAUSED "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk -v v=$PAUSED '{print $2 + v}')
	PAUSED=$(( ${PAUSED} + ${TEMP} ))
	TEMP=$(grep -i STOPPED "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk '{print $2}')
	if [ -z "${TEMP}" ] ; then TEMP=0 ; fi
#	STOPPED=$(grep -i STOPPED "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk -v v=$STOPPED '{print $2 + v}')
	STOPPED=$(( ${STOPPED} + ${TEMP} ))
	TEMP=$(grep -i IMAGES "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk '{print $2}')
	if [ -z "${TEMP}" ] ; then TEMP=0 ; fi
#	IMAGES=$(grep -i IMAGES "${DATA_DIR}"/"${CLUSTER}"/"${NODE}" | awk -v v=$IMAGES '{print $2 + v}')
	IMAGES=$(( ${IMAGES} + ${TEMP} ))
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      Add Docker information from ${NODE}.  CONTAINERS >$CONTAINERS< RUNNING >$RUNNING< PAUSED >$PAUSED< STOPPED >$STOPPED< IMAGES >$IMAGES<" 1>&2 ; fi
done
MESSAGE=" CONTAINERS ${CONTAINERS}  RUNNING ${RUNNING}  PAUSED ${PAUSED}  STOPPED ${STOPPED}  IMAGES ${IMAGES} . . . "
echo "${MESSAGE}" > "${DATA_DIR}"/"${CLUSTER}"/"${MESSAGE_FILE}"
cp "${DATA_DIR}"/"${CLUSTER}"/"${MESSAGE_FILE}" "${DATA_DIR}"/"${CLUSTER}"/"${MESSAGE_FILE}"HD
# >>>	NOT sure this is a good idea because how do you always know that ${LOCALHOST} has scrollphathd
# >>>	but does it matter .... ???
tail -n +6 "${DATA_DIR}"/"${CLUSTER}"/"${LOCALHOST}" >> "${DATA_DIR}"/"${CLUSTER}"/"${MESSAGE_FILE}"HD
# >>>	<<< <<< <<<

#	Loop through hosts in ${SYSTEMS_FILE} file and update other host information
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Loop through hosts in ${SYSTEMS_FILE} file and update remote host information" 1>&2 ; fi 
for NODE in $(cat "${DATA_DIR}"/"${CLUSTER}"/"${SYSTEMS_FILE}" | grep -v "#" ); do
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  --> Host ${NODE}" 1>&2 ; fi
#	Check if ${NODE} is ${LOCALHOST} skip already did before the loop
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#		Check if ${NODE} is available on ssh port
		if $(ssh "${NODE}" 'exit' >/dev/null 2>&1 ) ; then
			scp -q -p -i ~/.ssh/id_rsa ${DATA_DIR}/${CLUSTER}/*$(hostname -d) ${ADMUSER}@${NODE}:${DATA_DIR}/${CLUSTER} &
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      $(ls -l ${DATA_DIR}/${CLUSTER}/${NODE})" 1>&2 ; fi
			scp -q -p -i ~/.ssh/id_rsa ${DATA_DIR}/${CLUSTER}/log/$(hostname -f)\-crontab ${ADMUSER}@${NODE}:${DATA_DIR}/${CLUSTER}/log &
			TEMP="cd ${DATA_DIR}/${CLUSTER} ; ln -sf ${NODE} LOCAL-HOST"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      Copy complete to ${NODE}" 1>&2 ; fi
		else
			get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  --> Host ${NODE} found in ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file is  NOT  responding to ${LOCALHOST}." 1>&2
		fi
	fi
done
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Finished loop" 1>&2 ; fi
/bin/ln -sf "${LOCALHOST}" LOCAL-HOST	# very difficult to locate and solve bug fix #26

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}   Operation finished." 1>&2
###
