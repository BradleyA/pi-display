#!/bin/bash
# 	create-message/create-display-message.sh  3.407.686  2020-10-14T16:39:53.743896-05:00 (CDT)  https://github.com/BradleyA/pi-display  master  uadmin  five-rpi3b.cptx86.com 3.406  
# 	   create-message/create-display-message.sh -->   begin updating code to latest Production standards  
# 	create-message/create-display-message.sh  3.403.631  2019-08-09T13:50:45.279479-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  one-rpi3b.cptx86.com 3.402-2-g700767e  
# 	   create-message/create-display-message.sh change WARN to ERROR #73 
# 	create-message/create-display-message.sh  3.402.628  2019-05-05T23:44:27.278222-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  one-rpi3b.cptx86.com 3.401  
# 	   #73 debug addition with "" 
#86# create-message/create-display-message.sh
###  Production standard 5.3.559 Copyright                                    # 3.559
#    Copyright (c) 2020 Bradley Allen                                                # 3.555
#    MIT License is online in the repository as a file named LICENSE"         # 3.559
###  Production standard 3.0 shellcheck
###  Production standard 1.3.550 DEBUG variable                                             # 3.550
#    Order of precedence: environment variable, default code
if [[ "${DEBUG}" == ""  ]] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
if [[ "${DEBUG}" == "2" ]] ; then set -x    ; fi   # Print trace of simple commands before they are executed
if [[ "${DEBUG}" == "3" ]] ; then set -v    ; fi   # Print shell input lines as they are read
if [[ "${DEBUG}" == "4" ]] ; then set -e    ; fi   # Exit immediately if non-zero exit status
if [[ "${DEBUG}" == "5" ]] ; then set -e -o pipefail ; fi   # Exit immediately if non-zero exit status and exit if any command in a pipeline errors
#
BOLD=$(tput -Txterm bold)
UNDERLINE=$(tput -Txterm sgr 0 1)  # 0.3.583
NORMAL=$(tput -Txterm sgr0)
RED=$(tput    setaf 1)
GREEN=$(tput  setaf 2)
YELLOW=$(tput setaf 3)
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_ADM_TLS_USER="${USER}"
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"
DEFAULT_MESSAGE_FILE="MESSAGE"
DEFAULT_SYSTEMS_FILE="SYSTEMS"

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')                                               # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Store Docker and system information"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo -e "   ${COMMAND_NAME} [-c <CLUSTER>] [-d <DATA_DIR>] [-a <ADM_TLS_USER>] [-m <MESSAGE_FILE>] [-s <SYSTEMS_FILE>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.583 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8, en.UTF-8, C.UTF-8                  # 3.550
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
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

###  Production standard 4.3.587 Documentation Language                                     # 3.550
#    Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [[ "${LANG}" == "fr_CA.UTF-8" ]] || [[ "${LANG}" == "fr_FR.UTF-8" ]] || [[ "${LANG}" == "fr_CH.UTF-8" ]] ; then
  echo -e "\n--> ${LANG}"
  echo    "<Votre aide va ici>" # Your help goes here
  echo    "Souhaitez-vous traduire la section description?" # Would you like to translate the description section?
elif ! [[ "${LANG}" == "en_US.UTF-8" ||  "${LANG}" == "en.UTF-8" || "${LANG}" == "C.UTF-8" ]] ; then  # 3.550
  new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi

echo -e "\n${BOLD}ENVIRONMENT VARIABLES${NORMAL}"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the environment variable DEBUG to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the environment"
echo    "variable DEBUG.  You are on your own defining environment variables if"
echo    "you are using other shells."

###  Production standard 1.3.550 DEBUG variable                                             # 3.550
echo    "   DEBUG           (default off '0')  The DEBUG environment variable can be set"   # 3.550
echo    "                   to 0, 1, 2, 3, 4 or 5.  The setting '' or 0 will turn off"      # 3.550
echo    "                   all DEBUG messages during execution of this script.  The"       # 3.550
echo    "                   setting 1 will print all DEBUG messages during execution."      # 3.550
echo    "                   Setting 2 (set -x) will print a trace of simple commands"       # 3.550
echo    "                   before they are executed.  Setting 3 (set -v) will print"       # 3.550
echo    "                   shell input lines as they are read.  Setting 4 (set -e) will"   # 3.550
echo    "                   exit immediately if non-zero exit status is recieved with"      # 3.550
echo    "                   some exceptions.  Setting 5 (set -e -o pipefail) will do"       # 3.550
echo    "                   setting 4 and exit if any command in a pipeline errors.  For"   # 3.550
echo    "                   more information about the set options, see man bash."          # 3.550
#
echo    "   CLUSTER         Cluster name (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        Data directory (default '${DEFAULT_DATA_DIR}')"
echo    "   SYSTEMS_FILE    Name of file that includes hosts in cluster"
echo    "                   (default '${DEFAULT_SYSTEMS_FILE}')"
echo    "   MESSAGE_FILE    Name of file that stores Pimoroni Scroll-pHAT(-HD) message"
echo    "                   (default MESSAGE)"

echo    " [-a <ADM_TLS_USER>] "

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default value.\n"     # 3.572
echo    "   --help, -help, help, -h, h, -?"                                            # 3.572
echo -e "\tOn-line brief reference manual\n"                                           # 3.572
echo    "   --usage, -usage, -u"                                                       # 3.572
echo -e "\tOn-line command usage\n"                                                    # 3.572
echo    "   --version, -version, -v"                                                      # 0.3.579
echo -e "\tOn-line command version\n"                                                  # 3.572
#
echo    "   --cluster, -c, --cluster=<CLUSTER>, -c="
echo -e "\tCluster name (default '${DEFAULT_CLUSTER}')\n"
echo    "   --datadir, -d, --datadir=<DATA_DIR>, -d="
echo -e "\tData directory (default '${DEFAULT_DATA_DIR}')\n"
echo    "   --admuser, -a, --admuser=<ADM_TLS_USER>, -a="
echo -e "\tSite SRE administrator, default is user running script\n"
echo    "   --message, -m, --message=<MESSAGE_FILE>, -m=MESSAGE_FILE>"
echo -e "\tName of file that stores Pimoroni Scroll-pHAT(-HD) message\n\t(default '${DEFAULT_MESSAGE_FILE}')"
echo    "   --systems, -s, --systems=<SYSTEMS_FILE>, -s="
echo -e "\tName of systems file (default '${DEFAULT_SYSTEMS_FILE}')"

###  Production standard 6.3.547  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "/usr/local/data/                           <-- <DATA_DIR>"
echo    "└── <CLUSTER>/                             <-- <CLUSTER>"
echo    "    ├── SYSTEMS                            <-- List of hosts in cluster"
echo    "    ├── MESSAGE                            <-- Pimoroni Scroll-pHAT message"
echo    "    ├── MESSAGEHD                          <-- Pimoroni Scroll-pHAT-HD message"
echo    "    ├── log/                               <-- Host log directory"
echo    "    └── logrotate/                         <-- Host logrotate directory"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   ${UNDERLINE}https://github.com/BradleyA/pi-display#pi-display${NORMAL}"   # 0.3.583

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   <<description about code example>>\n\t${BOLD}${COMMAND_NAME} <<code example>>${NORMAL}\n" # 3.550
echo -e "   <<description about code example>>\n\t${BOLD}${COMMAND_NAME}${NORMAL}\n"        # 3.550
echo    "   To loop through a list of hosts a user could use, cluster-command.sh."          # 3.550
echo    "   An administrator may receive password and/or passphrase prompts from a"         # 3.550
echo    "   remote systen; running the following may stop the prompts."                     # 3.550
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<REMOTE_HOST>${NORMAL}\n"                            # 3.550
echo    "   or using the IP address"                                                          # 3.550
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<192.168.x.x>${NORMAL}\n"                            # 3.550
echo    "   If that does not resolve the prompting challenge then review man pages for"     # 3.550
echo    "   ssh-agent and ssh-add."                                                         # 3.550
echo    "   (${UNDERLINE}https://github.com/BradleyA/Linux-admin/tree/master/cluster-command#cluster-command ${NORMAL})"  # 0.3.583
echo -e "\t${BOLD}cluster-command.sh special '${COMMAND_NAME}'${NORMAL}\n"                  # 3.550

echo -e "\n${BOLD}SEE ALSO${NORMAL}"                                                        # 3.550
echo    "   ${BOLD}setup-pi-display.sh${NORMAL} (${UNDERLINE}https://github.com/BradleyA/pi-display/blob/master/setup-pi-display.sh ${NORMAL})"  # 0.3.583
echo    "   ${BOLD}uninstall-pi-display.sh${NORMAL} (${UNDERLINE}https://github.com/BradleyA/pi-display/blob/master/uninstall-pi-display.sh ${NORMAL})"

echo -e "\n${BOLD}AUTHOR${NORMAL}"                                                          # 3.550
echo    "   ${COMMAND_NAME} was written by Bradley Allen <allen.bradley@ymail.com>"         # 3.550

echo -e "\n${BOLD}REPORTING BUGS${NORMAL}"                                                  # 3.550
echo    "   Report ${COMMAND_NAME} bugs ${UNDERLINE}https://github.com/BradleyA/pi-display/issues/new/choose ${NORMAL}"  # 0.3.583

###  Production standard 5.3.559 Copyright                                            # 3.559
echo -e "\n${BOLD}COPYRIGHT${NORMAL}"                                                       # 3.550
echo    "   Copyright (c) 2020 Bradley Allen"                                               # 3.550
echo    "   MIT License is online in the repository as a file named LICENSE"          # 3.559
}

#    Date and time function ISO 8601
get_date_stamp() {
  DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
  TEMP=$(date +%Z)
  DATE_STAMP="${DATE_STAMP} (${TEMP})"
}

#    Fully qualified domain name FQDN hostname
LOCALHOST=$(hostname -f)

#    Version
#    Assumptions for the next two lines of code:  The second line in this script includes the script path & name as the second item and
#    the script version as the third item separated with space(s).  The tool I use is called 'markit'. See example line below:
#       template/template.sh  3.517.783  2019-09-13T18:20:42.144356-05:00 (CDT)  https://github.com/BradleyA/user-files.git  uadmin  one-rpi3b.cptx86.com 3.516  
SCRIPT_NAME=$(head -2 "${0}" | awk '{printf $2}')  #  Different from ${COMMAND_NAME}=$(echo "${0}" | sed 's/^.*\///'), SCRIPT_NAME = includes Git repository directory and can be used any where in script (for dev, test teams)
SCRIPT_VERSION=$(head -2 "${0}" | awk '{printf $3}')
if [[ "${SCRIPT_NAME}" == "" ]] ; then SCRIPT_NAME="${0}" ; fi
if [[ "${SCRIPT_VERSION}" == "" ]] ; then SCRIPT_VERSION="v?.?" ; fi

#    GID
GROUP_ID=$(id -g)

###  Production standard 2.3.578 Log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
new_message() {  #  $1="${LINENO}"  $2="DEBUG INFO ERROR WARN"  $3="message"
  get_date_stamp
  echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${SCRIPT_NAME}[$$] ${BOLD}${BLUE}${SCRIPT_VERSION} ${PURPLE}${1}${NORMAL} ${USER} ${UID}:${GROUP_ID} ${BOLD}[${2}]${NORMAL}  ${3}"
}

#    INFO
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Started..." 1>&2

#    Added following code because USER is not defined in crobtab jobs
if ! [[ "${USER}" == "${LOGNAME}" ]] ; then  USER=${LOGNAME} ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Setting USER to support crobtab...  USER >${YELLOW}${USER}${WHITE}<  LOGNAME >${YELLOW}${LOGNAME}${WHITE}<" 1>&2 ; fi  #  2.3.578

#    DEBUG
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Name_of_command >${YELLOW}${SCRIPT_NAME}${WHITE}< Name_of_arg1 >${YELLOW}${1}${WHITE}< Name_of_arg2 >${YELLOW}${2}${WHITE}< Name_of_arg3 >${YELLOW}${3}${WHITE}<  Version of bash ${YELLOW}${BASH_VERSION}${WHITE}" 1>&2 ; fi  #  2.3.578




#	Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi



#	Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#	order of precedence: CLI argument, default code
ADM_TLS_USER=${2:-${USER}}
#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then DATA_DIR=${3} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  4 ]  ; then MESSAGE_FILE=${4} ; elif [ "${MESSAGE_FILE}" == "" ] ; then MESSAGE_FILE="MESSAGE" ; fi
#	order of precedence: CLI argument, environment variable, default code
if [ $# -ge  5 ]  ; then SYSTEMS_FILE=${5} ; elif [ "${SYSTEMS_FILE}" == "" ] ; then SYSTEMS_FILE="SYSTEMS" ; fi
#
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  CLUSTER >${CLUSTER}< ADM_TLS_USER >${ADM_TLS_USER}< DATA_DIR >${DATA_DIR}< MESSAGE_FILE >${MESSAGE_FILE}< SYSTEMS_FILE >${SYSTEMS_FILE}< PATH >${PATH}<" 1>&2 ; fi

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
	mkdir -p  ${DATA_DIR} || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADM_TLS_USER} does not have permission to create ${DATA_DIR} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}
fi

#       Check if cluster directory is on system
if [ ! -d "${DATA_DIR}"/"${CLUSTER}"/log ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Creating missing directory: ${DATA_DIR}/${CLUSTER}" 1>&2
	mkdir -p  ${DATA_DIR}/${CLUSTER}/log || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADM_TLS_USER} does not have permission to create ${DATA_DIR}/${CLUSTER} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}/${CLUSTER}
	chmod 770 ${DATA_DIR}/${CLUSTER}/log
	mkdir -p  ${DATA_DIR}/${CLUSTER}/logrotate
	chmod 770 ${DATA_DIR}/${CLUSTER}/logrotate
fi

#	Create ${MESSAGE_FILE} file 1) create file for initial running on host, 2) check for write permission
touch ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADM_TLS_USER} does not have permission to create ${MESSAGE_FILE} file" 1>&2 ; exit 1; }
touch ${DATA_DIR}/${CLUSTER}/${MESSAGE_FILE}HD  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User ${ADM_TLS_USER} does not have permission to create ${MESSAGE_FILE}HD file" 1>&2 ; exit 1; }

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
			scp -q    -i ~/.ssh/id_rsa ${ADM_TLS_USER}@${NODE}:${DATA_DIR}/${CLUSTER}/${NODE} ${DATA_DIR}/${CLUSTER} &
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
		scp -q    -i ~/.ssh/id_rsa ${ADM_TLS_USER}@${NODE}:${DATA_DIR}/${CLUSTER}/${NODE} ${DATA_DIR}/${CLUSTER} &
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
			scp -q -p -i ~/.ssh/id_rsa ${DATA_DIR}/${CLUSTER}/*$(hostname -d) ${ADM_TLS_USER}@${NODE}:${DATA_DIR}/${CLUSTER} &
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}      $(ls -l ${DATA_DIR}/${CLUSTER}/${NODE})" 1>&2 ; fi
			scp -q -p -i ~/.ssh/id_rsa ${DATA_DIR}/${CLUSTER}/log/$(hostname -f)\-crontab ${ADM_TLS_USER}@${NODE}:${DATA_DIR}/${CLUSTER}/log &
			TEMP="cd ${DATA_DIR}/${CLUSTER} ; ln -sf ${NODE} LOCAL-HOST"
			ssh -q -t -i ~/.ssh/id_rsa ${ADM_TLS_USER}@${NODE} ${TEMP}
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
