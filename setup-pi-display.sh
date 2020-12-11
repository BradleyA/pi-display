#!/bin/bash
# 	setup-pi-display.sh  3.408.707  2020-12-11T13:16:45.111184-06:00 (CST)  https://github.com/BradleyA/pi-display  master  uadmin  five-rpi3b.cptx86.com 3.407-20-g62a1375  
# 	   create-message/create-display-message.sh setup-pi-display.sh -->   Production standard 1.3.614 DEBUG variable  Production standard 0.3.615 --help  Production standard 2.3.614 Log format  AND MAJOR FORMATTING CHANGES  
# 	setup-pi-display.sh  3.406.685  2020-10-14T14:11:35.686695-05:00 (CDT)  https://github.com/BradleyA/pi-display  master  uadmin  five-rpi3b.cptx86.com 3.405  
# 	   setup-pi-display.sh -->   testing  
# 	setup-pi-display.sh  3.404.683  2020-10-09T21:21:14.339160-05:00 (CDT)  https://github.com/BradleyA/pi-display  master  uadmin  five-rpi3b.cptx86.com 3.403-51-g1d99bb9  
# 	   setup-pi-display.sh -->   upgrade Production standard & run shellcheck  
# 	setup-pi-display.sh  3.366.552  2019-01-18T21:09:55.155962-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.365  
# 	   update info user  output uninstall-pi-display.sh close #66 
# 	setup-pi-display.sh  3.352.538  2019-01-18T17:08:36.462188-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.351  
# 	   changes to default user and group when not enter on command line 
# 	setup-pi-display.sh  3.349.535  2019-01-18T13:50:34.742312-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.348  
# 	   incident with rm: cannot remove '/usr/local/data//us-tx-cluster-1/log/one-rpi3b.cptx86.com-crontab': No such file or directory 
# 	setup-pi-display.sh  3.345.531  2019-01-18T12:16:22.571497-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.344  
# 	   comment out rm -rf pi-display/ to test uninstall-pi-display.sh #58 #66 
# 	setup-pi-display.sh  3.342.528  2019-01-17T23:26:50.090543-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.341  
# 	   added output when directory is being removed 
# 	setup-pi-display.sh  3.341.527  2019-01-17T23:23:46.163129-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.340  
# 	   check for and if true remove ./pi-display/ 
#
#86# setup-pi-display.sh - setup system to gather and display Docker & System info
###  Production standard 5.3.559 Copyright                                    # 3.559
#    Copyright (c) 2020 Bradley Allen                                                # 3.555
#    MIT License is online in the repository as a file named LICENSE"         # 3.559
###  Production standard 3.0 shellcheck
###  Production standard 1.3.550 DEBUG variable                                             # 3.550
#    Order of precedence: environment variable, default code
DEBUG=1


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
YELLOW=$(tput setaf 3)
BLUE=$(tput   setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput   setaf 6)
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"
DEFAULT_SYSTEMS_FILE="SYSTEMS"

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')                                               # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   setup system to gather and display Docker & System info"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo -e "   sudo ${COMMAND_NAME}\n"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   sudo ${COMMAND_NAME} [<CLUSTER>]"
echo    "   sudo ${COMMAND_NAME}  <CLUSTER> [<DATA_DIR>]"
echo    "   sudo ${COMMAND_NAME}  <CLUSTER>  <DATA_DIR> [<ADMUSER>]"
echo    "   sudo ${COMMAND_NAME}  <CLUSTER>  <DATA_DIR>  <ADMUSER> [<ADMGRP>]"
echo -e "   sudo ${COMMAND_NAME}  <CLUSTER>  <DATA_DIR>  <ADMUSER>  <ADMGRP> [<EMAIL_ADDRESS>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.583 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8, en.UTF-8, C.UTF-8                  # 3.550
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "This script has to be run as root to create ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}."
echo    "The commands are installed in <DATA_DIR>/ and will store logs, Docker and"
echo    "system information into ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER} directory.  The"
echo    "Docker information includes the number of containers, running containers,"
echo    "paused containers, stopped containers, and number of images.  The system"
echo    "information includes cpu temperature in Celsius and Fahrenheit, the system"
echo    "load, memory usage, and disk usage."
echo -e "\nThe information in ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}<hostname> file is created"
echo    "by ${BOLD}create-host-info.sh${NORMAL} and can be used by ${BOLD}display-led.py${NORMAL} for Raspberry Pi with"
echo    "Pimoroni Blinkt to display the system information in near real time.  It is"
echo    "also used by ${BOLD}create-display-message.sh${NORMAL}.  The <hostname> files are copied to"
echo    "each host found in ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}${DEFAULT_SYSTEMS_FILE} and totaled in a"
echo    "file, ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}MESSAGE and MESSAGEHD.  The MESSAGE files"
echo    "include the total number of containers, running containers, paused containers,"
echo    "stopped containers, and number of images.  The MESSAGE files are used by a"
echo    "Raspberry Pi with Pimoroni Scroll-pHAT or Pimoroni Scroll-pHAT-HD to display"
echo    "the information."
echo -e "\nThis script reads ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}${DEFAULT_SYSTEMS_FILE} file for hosts."
echo    "The hosts are one FQDN or IP address per line for all hosts in a cluster."
echo    "Lines in SYSTEMS file that begin with a # are comments.  The SYSTEMS file is"
echo    "used by Linux-admin/cluster-command/cluster-command.sh, markit/find-code.sh,"
echo    "pi-display/create-message/create-display-message.sh, and other scripts."

##  Production standard 4.3.587 Documentation Language                                     # 3.550
#    Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [[ "${LANG}" == "fr_CA.UTF-8" ]] || [[ "${LANG}" == "fr_FR.UTF-8" ]] || [[ "${LANG}" == "fr_CH.UTF-8" ]] ; then
  echo -e "\n--> ${LANG}"
	echo    "Ce script doit être exécuté en tant que root pour cr"
	echo    "${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}. le Les commandes sont installées dan"
	echo    "/usr/local/bin et stockent les journaux, Docker et informations système dan"
	echo    "le répertoire ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}. Le docker l'information comprend l"
	echo    "nombre de conteneurs, les conteneurs en cours d'exécution, en paus"
	echo    "conteneurs, conteneurs arrêtés et nombre d'images. Les informations systè"
	echo    "comprend la température du processeur en Celsius et Fahrenheit, la charge d"
	echo    "système, la mémoire utilisation et utilisation du disqu"
	echo -e "\nLes informations contenues dans le fichier"
	echo    "${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}<nomhôte> sont créées par create-host-info.sh"
	echo    "peut être utilisé par display-led.py pour Raspberry Pi avec Pimoroni Blin"
	echo    "pour afficher les informations système en temps quasi réel. Il est"
	echo    "également utilisé par create-display-message.sh. Les fichiers <nom d'hô"
	echo    "sont copiés dans chaque hôte trouvé dans ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}${DEFAULT_SYSTEMS_FILE}"
	echo    "et totalisé dans un fichier, ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}MESSAGE et MESSAGEHD"
	echo    "Les fichiers MESSAGE incluent le nombre total de conteneurs, de conteneurs"
	echo    "en cours d'exécution, de conteneurs en pause, conteneurs arrêtés et nom"
	echo    "d'images. Les fichiers MESSAGE sont utilisés par un Raspberry Pi ave"
	echo    "Pimoroni Scroll-pHAT ou Pimoroni Scroll-pHAT-HD afficher les informations."
	echo -e "\nCe script lit le fichier ${DEFAULT_DATA_DIR}${DEFAULT_CLUSTER}${DEFAULT_SYSTEMS_FILE} pour les"
	echo    "hôtes.  Les hôtes correspondenun nom de domaine complet ou une adresse"
	echo    "IP par ligne pour tous les hôtes d'un cluster.  Les lignes du fichier"
	echo    "SYSTEMS commençant par un # sont des commentaires. Le fichier SYSTEMS est"
	echo    "utilisé par Linux-admin/commande-cluster/commande-cluster.sh"
	echo    "markit/find-code.sh, pi-display/create-message/create-display-message.sh"
	echo    "et d’autres scripts"
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

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default value.\n"     # 3.572
echo    "   --help, -help, help, -h, h, -?"                                            # 3.572
echo -e "\tOn-line brief reference manual\n"                                           # 3.572
echo    "   --usage, -usage, -u"                                                       # 3.572
echo -e "\tOn-line command usage\n"                                                    # 3.572
echo    "   --version, -version, -v"                                                      # 0.3.579
echo -e "\tOn-line command version\n"                                                  # 3.572
#
echo -e "   CLUSTER\n\tCluster name (default '${DEFAULT_CLUSTER}')\n"
echo -e "   DATA_DIR\n\tData directory (default '${DEFAULT_DATA_DIR}')\n"
echo -e "   ADMUSER\n\tSite SRE administrator, default is root\n"
echo -e "   ADMGRP\n\tSite SRE group, default is root\n"
echo -e "   EMAIL_ADDRESS\n\tSRE email address"

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
echo    "   ${UNDERLINE}https://github.com/BradleyA/pi-display${NORMAL}"  # 0.3.583

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Setup system to gather and display Docker & System info for us-tx-cluster-1\n   cluster in /usr/local/data directory for user uadmin group uadmin\n   with user@EMAIL_ADDRESS email address.\n\t${BOLD}${COMMAND_NAME}sudo ${0} us-tx-cluster-1 /usr/local/data uadmin uadmin user@EMAIL_ADDRESS${NORMAL}\n" # 3.550

echo -e "\n${BOLD}SEE ALSO${NORMAL}"                                                        # 3.550
echo    "   ${BOLD}uninstall-pi-display.sh${NORMAL} (${UNDERLINE}https://github.com/BradleyA/pi-display${NORMAL})"  # 0.3.583

echo -e "\n${BOLD}AUTHOR${NORMAL}"                                                          # 3.550
echo    "   ${COMMAND_NAME} was written by Bradley Allen <allen.bradley@ymail.com>"         # 3.550

echo -e "\n${BOLD}REPORTING BUGS${NORMAL}"                                                  # 3.550
echo    "   Report ${COMMAND_NAME} bugs ${UNDERLINE}https://github.com/BradleyA/pi-display/issues/new/choose${NORMAL}"  # 0.3.583

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

###  Production standard 9.3.562 Parse CLI options and arguments
while [[ "${#}" -gt 0 ]] ; do
  case "${1}" in
    --help|-help|help|-h|h|-\?)  display_help | more ; exit 0 ;;
    --usage|-usage|usage|-u)  display_usage ; exit 0  ;;
    --version|-version|version|-v)  echo "${SCRIPT_NAME} ${SCRIPT_VERSION}" ; exit 0  ;;
    *) break ;;
  esac
done

#    Root is required to copy certs
if ! [[ "${UID}"  = 0 ]] ; then
  display_usage | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Use sudo ${SCRIPT_NAME}" 1>&2
  #    Help hint
  echo -e "\n\t${BOLD}>>   ${YELLOW}SCRIPT MUST BE RUN AS ROOT${WHITE}   <<\n${NORMAL}"  1>&2
  exit 1
fi

###
set -v

#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then DATA_DIR=${2} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#       Order of precedence: CLI argument
if [ $# -ge  3 ]  ; then ADMUSER=${3} ; else "${ADMUSER}" == "$(whoami)" ; echo -e "\n\t${BOLD}Warning:  ${ADMUSER} will be used for crontab . . ." ; fi
#       Order of precedence: CLI argument
if [ $# -ge  4 ]  ; then ADMGRP=${4} ; else "${ADMGRP}" == "$(groups | cut -d' ' -f1)" ; echo -e "\n\t${BOLD}Warning:  ${ADMGRP} will be used for crontab . . ." ; fi
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  5 ]  ; then EMAIL_ADDRESS=${5} ; elif [ "${EMAIL_ADDRESS}" == "" ] ; then EMAIL_ADDRESS="root@${LOCALHOST}" ; fi
if [ "${DEBUG}" == "1" ] ; then new_message "${LINENO}" "DEBUG" "  Variable... CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}< ADMUSER >${ADMUSER}< ADMGRP >${ADMGRP}< EMAIL_ADDRESS >${EMAIL_ADDRESS}<" 1>&2 ; fi

set +v


#
mkdir -p /usr/local/bin
mkdir -p "${DATA_DIR}"/"${CLUSTER}"/log
mkdir -p "${DATA_DIR}"/"${CLUSTER}"/logrotate

#   Change directory owner and group
chown    "${ADMUSER}":"${ADMGRP}" /usr/local/bin
chown -R "${ADMUSER}":"${ADMGRP}" "${DATA_DIR}"

#   Change file mode bits
chmod 0775 /usr/local/bin
chmod 0775 "${DATA_DIR}"
chmod 0775 "${DATA_DIR}"/"${CLUSTER}"
chmod 0770 "${DATA_DIR}"/"${CLUSTER}"/log
chmod 0770 "${DATA_DIR}"/"${CLUSTER}"/logrotate

#   Move files
cp pi-display-logrotate                       "${DATA_DIR}"/"${CLUSTER}"/logrotate
cp blinkt/display-led.py                      /usr/local/bin
cp blinkt/display-led-test.py                 /usr/local/bin
cp create-message/CPU_usage.sh                /usr/local/bin
cp create-message/create-display-message.sh   /usr/local/bin
cp create-message/create-host-info.sh         /usr/local/bin
cp scrollphat/display-message.py              /usr/local/bin
cp scrollphat/display-scrollphat-test.py      /usr/local/bin
cp scrollphathd/display-message-hd.py         /usr/local/bin
cp scrollphathd/display-scrollphathd-test.py  /usr/local/bin

#   Change file owner and group
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/display-led.py
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/display-led-test.py
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/CPU_usage.sh
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/create-display-message.sh
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/create-host-info.sh
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/display-message.py
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/display-scrollphat-test.py
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/display-message-hd.py
chown "${ADMUSER}":"${ADMGRP}" /usr/local/bin/display-scrollphathd-test.py

#   Change file mode bits
chmod 0660 ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
chmod 0770 /usr/local/bin/display-led.py
chmod 0770 /usr/local/bin/display-led-test.py
chmod 0775 /usr/local/bin/CPU_usage.sh
chmod 0770 /usr/local/bin/create-display-message.sh
chmod 0770 /usr/local/bin/create-host-info.sh
chmod 0770 /usr/local/bin/display-message.py
chmod 0770 /usr/local/bin/display-scrollphat-test.py
chmod 0770 /usr/local/bin/display-message-hd.py
chmod 0770 /usr/local/bin/display-scrollphathd-test.py

#       Check if SYSTEMS file on system
if ! [[ -e ${DATA_DIR}/${CLUSTER}/SYSTEMS ]] ; then
	echo -e "\n\t${NORMAL}${DATA_DIR}/${CLUSTER}/SYSTEMS file not found ..."
	echo -e "\tCreating ${DATA_DIR}/${CLUSTER}/SYSTEMS file adding local host."
	echo -e "\n\t${BOLD}Edit ${DATA_DIR}/${CLUSTER}/SYSTEMS to add additional hosts.${NORMAL}"
	echo "###     List of hosts in cluster" >    "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	echo "#       Used by markit/find-code.sh, Linux-admin/cluster-command/cluster-command.sh," >> "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	echo "#       pi-display/create-message/create-display-message.sh, and other scripts." >> "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	echo "###" >> "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	echo "#       One FQDN or IP address on each line" >> "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	echo "###" >> "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	echo "${LOCALHOST}" >> "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	chown "${ADMUSER}":"${ADMGRP}" "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
	chmod 0664 "${DATA_DIR}"/"${CLUSTER}"/SYSTEMS
fi

###	crontab
if [[ -e /var/spool/cron/crontabs/${ADMUSER} ]] ; then
	echo -e "\n\tCreating a copy of /var/spool/cron/crontabs/${ADMUSER}" 1>&2
	DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
	cp /var/spool/cron/crontabs/"${ADMUSER}" /var/spool/cron/crontabs/"${ADMUSER}"."${DATE_STAMP}"
	chown "${ADMUSER}":"${ADMGRP}" /var/spool/cron/crontabs/"${ADMUSER}"."${DATE_STAMP}"
	chmod 0660 /var/spool/cron/crontabs/"${ADMUSER}"."${DATE_STAMP}"
fi
touch /var/spool/cron/crontabs/"${ADMUSER}"
#
echo -e "\n\tUpdating /var/spool/cron/crontabs/${ADMUSER}" 1>&2
###	Raspberry Pi with blinkt for pi-display
echo    "# DO NOT EDIT THIS FILE - edit the master and reinstall."  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# "  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# (Cron version -- $Id: crontab.c,v 2.13 1994/01/17 03:20:37 vixie Exp $)"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "#   Edit this file to introduce tasks to be run by cron."  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "#   Raspberry Pi with blinkt for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "#   Uncomment the following 7 lines on Raspberry Pi with blinkt installed for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# @reboot   /usr/local/bin/display-led-test.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# * * * * *            /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# * * * * * sleep 5  ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# * * * * * sleep 20 ; /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# * * * * * sleep 25 ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "* * * * * sleep 40 ; /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# * * * * * sleep 45 ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
###     Raspberry Pi with scroll-pHAT for pi-display
echo -e "#\n#   scroll-pHAT for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "#   Uncomment the following 3 lines and the line above which includes sleep 40 ; ... create-host-info.sh ... on Raspberry Pi with scroll-pHAT for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# @reboot   /usr/local/bin/display-scrollphat-test.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# */2 * * * *      /usr/local/bin/create-display-message.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# 1-59/2 * * * *   /usr/local/bin/display-message.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
###	Raspberry Pi with scroll-pHAT-HD for pi-display
echo -e "#\n#   scroll-pHAT-HD for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "#   Uncomment the following 3 lines and the line above which includes sleep 40 ; ... create-host-info.sh ... on Raspberry Pi with scroll-pHAT HD for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# @reboot   /usr/local/bin/display-scrollphathd-test.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# */2 * * * *      /usr/local/bin/create-display-message.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# 1-59/2 * * * *   /usr/local/bin/display-message-hd.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
###     All Raspberry Pi's that include any above section to rotate logs for pi-display
echo -e "#\n#   All Raspberry Pi's that include any above section to rotate logs for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "#   Uncomment the following line to rotate logs for pi-display"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# 6 */2 * * * /usr/sbin/logrotate -s /usr/local/data/us-tx-cluster-1/logrotate/status /usr/local/data/us-tx-cluster-1/logrotate/pi-display-logrotate >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
###     Prometheus exporter for hardware and OS metrics exposed by *NIX kernels
echo -e "#\n#   Prometheus exporter for hardware and OS metrics exposed by *NIX kernels"  >> /var/spool/cron/crontabs/"${ADMUSER}"
echo    "# @reboot /usr/local/bin/node_exporter >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/"${ADMUSER}"
#
chown "${ADMUSER}":crontab /var/spool/cron/crontabs/"${ADMUSER}"
chmod 0600 /var/spool/cron/crontabs/"${ADMUSER}"
echo -e "\n\t${BOLD}Edit /var/spool/cron/crontabs/${ADMUSER} using crontab -e" 1>&2
echo -e "\tUncomment the section that is needed for your Raspberry Pi${NORMAL}" 1>&2

###	pi-display-logrotate - logrotate conf file
echo -e "#\n#\n#" > ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "${DATA_DIR}/${CLUSTER}/log/${LOCALHOST}-crontab {"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    daily"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate  
echo    "    su ${ADMUSER} ${ADMGRP}"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    rotate 60"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    create 0660 ${ADMUSER} ${ADMGRP}"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "#    compress"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    size 25"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    olddir ../logrotate"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    notifempty"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    mail ${EMAIL_ADDRESS}"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    prerotate"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        TMP=\$(/bin/ls -l ${DATA_DIR}/${CLUSTER}/log/${LOCALHOST}-crontab)"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        /bin/echo 'INFO: '\${TMP} >> ${DATA_DIR}/${CLUSTER}/log/${LOCALHOST}-crontab"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        /bin/grep -nv '\[INFO\]' ${DATA_DIR}/${CLUSTER}/log/${LOCALHOST}-crontab | grep -iv 'info' > ${DATA_DIR}/${CLUSTER}/logrotate/incident"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        /bin/grep -B 1 -A 1 -ni '\[WARN\]\|ERROR' ${DATA_DIR}/${CLUSTER}/log/${LOCALHOST}-crontab >> ${DATA_DIR}/${CLUSTER}/logrotate/incident"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        DATE_TMP=\$(date +%Y-%m-%dT%H.%M)"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        /bin/echo \${DATE_TMP} > ${DATA_DIR}/${CLUSTER}/logrotate/EXT"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        /usr/bin/sort -n -u ${DATA_DIR}/${CLUSTER}/logrotate/incident | grep -v '\-\-$' > ${DATA_DIR}/${CLUSTER}/logrotate/\${DATE_TMP}-incident"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        [ -s ${DATA_DIR}/${CLUSTER}/logrotate/\${DATE_TMP}-incident ] && /usr/bin/mail -s 'incident report: '\${DATE_TMP}-${LOCALHOST}-crontab ${EMAIL_ADDRESS} < ${DATA_DIR}/${CLUSTER}/logrotate/\${DATE_TMP}-incident"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        [ -e ${DATA_DIR}/${CLUSTER}/logrotate/incident ] && /bin/rm ${DATA_DIR}/${CLUSTER}/logrotate/incident"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    endscript"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    postrotate"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        FILE=\$(cat ${DATA_DIR}/${CLUSTER}/logrotate/EXT)"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "        /bin/mv ${DATA_DIR}/${CLUSTER}/logrotate/${LOCALHOST}-crontab.1 ${DATA_DIR}/${CLUSTER}/logrotate/\${FILE}-${LOCALHOST}-crontab"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "    endscript"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
echo    "}"  >>  ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
#
chown "${ADMUSER}":"${ADMGRP}" "${DATA_DIR}"/"${CLUSTER}"/logrotate/pi-display-logrotate
chmod 0660 "${DATA_DIR}"/"${CLUSTER}"/logrotate/pi-display-logrotate

###	remove clone directories and files
cd ..
#       Check if directory 
if [[ -d ./pi-display ]] ; then
	echo -e "\n\tRemoving directory ./pi-display"
#	rm -rf ./pi-display/
echo  ">>>>>>>>>>>>>>....... crap don't do this until I save it <<<<<<<<<<<<<<<"
else
	new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  ./pi-display/ directory not found"  1>&2
fi

new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
