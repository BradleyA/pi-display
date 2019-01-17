#!/bin/bash
# 	setup-pi-display.sh  3.335.521  2019-01-17T16:31:31.710873-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.334  
# 	   testing setup script 
# 	setup-pi-display.sh  3.334.520  2019-01-17T16:25:24.268804-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.333  
# 	   rotate log files #58 
# 	setup-pi-display.sh  3.318.504  2019-01-12T15:24:43.647544-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.317  
# 	   template.[sh,py] production standard 4 change display_help of other LANG 
# 	setup-pi-display.sh  3.317.503  2019-01-11T14:44:23.411002-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.316  
# 	   security: check log & script file and directory permissions close #55 
#
### setup-pi-display.sh
#   production standard 4
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - setup system to gather and display Docker & System info"
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [<CLUSTER>] [<DATA_DIR>] [<ADMUSER>] [ADMGRP] [EMAIL_ADDRESS]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "This script has to be run as root to create /usr/local/data/<CLUSTER>.  The"
echo    "commands are installed in /usr/local/bin and will store logs, Docker and"
echo    "system information into /usr/local/data/<CLUSTER> directory.  The Docker"
echo    "information includes the number of containers, running containers, paused"
echo    "containers, stopped containers, and number of images.  The system information"
echo    "includes cpu temperature in Celsius and Fahrenheit, the system load, memory"
echo    "usage, and disk usage."
echo -e "\nThe information in /usr/local/data/<CLUSTER>/<hostname> file is created by"
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
#       Displaying help DESCRIPTION in French
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
	echo    "Ce script doit être exécuté en tant que root pour cr"
	echo    "/usr/local/data/<CLUSTER>. le Les commandes sont installées dan"
	echo    "/usr/local/bin et stockent les journaux, Docker et informations système dan"
	echo    "le répertoire /usr/local/data/<CLUSTER>. Le docker l'information comprend l"
	echo    "nombre de conteneurs, les conteneurs en cours d'exécution, en paus"
	echo    "conteneurs, conteneurs arrêtés et nombre d'images. Les informations systè"
	echo    "comprend la température du processeur en Celsius et Fahrenheit, la charge d"
	echo    "système, la mémoire utilisation et utilisation du disqu"
	echo -e "\nLes informations contenues dans le fichier"
	echo    "/usr/local/data/<CLUSTER>/<nomhôte> sont créées par create-host-info.sh"
	echo    "peut être utilisé par display-led.py pour Raspberry Pi avec Pimoroni Blin"
	echo    "pour afficher les informations système en temps quasi réel. Il est"
	echo    "également utilisé par create-display-message.sh. Les fichiers <nom d'hô"
	echo    "sont copiés dans chaque hôte trouvé dans /usr/local/data/<CLUSTER>/SYST"
	echo    "et totalisé dans un fichier, /usr/local/data/<CLUSTER>/ MESSAGE et MESSAGEHD"
	echo    "Les fichiers MESSAGE incluent le nombre total de conteneurs, de conteneurs"
	echo    "en cours d'exécution, de conteneurs en pause, conteneurs arrêtés et nom"
	echo    "d'images. Les fichiers MESSAGE sont utilisés par un Raspberry Pi ave"
	echo    "Pimoroni Scroll-pHAT ou Pimoroni Scroll-pHAT-HD afficher les informations."
	echo -e "\nCe script lit le fichier /usr/local/data/<CLUSTER>/ SYSTEMS pour les"
	echo    "hôtes.  Les hôtes correspondenun nom de domaine complet ou une adresse"
	echo    "IP par ligne pour tous les hôtes d'un cluster.  Les lignes du fichier"
	echo    "SYSTEMS commençant par un # sont des commentaires. Le fichier SYSTEMS est"
	echo    "utilisé par Linux-admin/commande-cluster/commande-cluster.sh"
	echo    "markit/find-code.sh, pi-display/create-message/create-display-message.sh"
	echo    "et d’autres scripts"
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  To set an environment variable to be defined at login,"
echo    "add it to ~/.bashrc file or you can modify this script with your default"
echo    "location.  You are on your own defining environment variables if you are"
echo    "using other shells."
echo    "   CLUSTER         (default us-tx-cluster-1/)"
echo    "   DATA_DIR        (default /usr/local/data/)"
echo    "   DEBUG           (default '0')"
echo -e "\nOPTIONS"
echo    "   CLUSTER         name of cluster directory, default us-tx-cluster-1"
echo    "   DATA_DIR        path to cluster data directory, default /usr/local/data/"
echo    "   ADMUSER         site SRE administrator, default is user running script"
echo    "   ADMGRP          site SRE group, default is group running script"
echo    "   EMAIL_ADDRESS   SRE email address"
echo -e "\nDOCUMENTATION\n    https://github.com/BradleyA/pi-display-board"
echo -e "\nEXAMPLES\n   sudo ${0}\n"
echo -e "   sudo ${0} us-tx-cluster-1 /usr/local/data uadmin uadmin\n"
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
if ! [ $(id -u) = 0 ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
	echo -e "\n>>   ${BOLD}SCRIPT MUST BE RUN AS ROOT${NORMAL} <<"  1>&2
        exit 1
fi

#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then DATA_DIR=${2} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
#       Order of precedence: CLI argument, default code
ADMUSER=${3:-$(id -u)}
#       Order of precedence: CLI argument, default code
ADMGRP=${4:-$(id -g)}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  5 ]  ; then EMAIL_ADDRESS=${5} ; elif [ "${EMAIL_ADDRESS}" == "" ] ; then EMAIL_ADDRESS="root@${LOCALHOST}" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}< ADMUSER >${ADMUSER}< ADMGRP >${ADMGRP}< EMAIL_ADDRESS >${EMAIL_ADDRESS}<" 1>&2 ; fi

#
mkdir -p /usr/local/bin
mkdir -p ${DATA_DIR}/${CLUSTER}/log
mkdir -p ${DATA_DIR}/${CLUSTER}/logrotate

#   Change directory owner and group
chown    ${ADMUSER}:${ADMGRP} /usr/local/bin
chown -R ${ADMUSER}:${ADMGRP} ${DATA_DIR}

#   Change file mode bits
chmod 0775 /usr/local/bin
chmod 0775 ${DATA_DIR}
chmod 0775 ${DATA_DIR}/${CLUSTER}
chmod 0770 ${DATA_DIR}/${CLUSTER}/log
chmod 0770 ${DATA_DIR}/${CLUSTER}/logrotate

#   Move files
cp pi-display-logrotate                       ${DATA_DIR}/${CLUSTER}/logrotate
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
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/display-led.py
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/display-led-test.py
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/CPU_usage.sh
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/create-display-message.sh
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/create-host-info.sh
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/display-message.py
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/display-scrollphat-test.py
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/display-message-hd.py
chown ${ADMUSER}:${ADMGRP} /usr/local/bin/display-scrollphathd-test.py

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
if ! [ -e ${DATA_DIR}/${CLUSTER}/SYSTEMS ] ; then
	echo -e "\n\t${NORMAL}${DATA_DIR}/${CLUSTER}/SYSTEMS file not found ..."
	echo -e "\tCreating ${DATA_DIR}/${CLUSTER}/SYSTEMS file adding local host."
	echo -e "\n\t${BOLD}Edit ${DATA_DIR}/${CLUSTER}/SYSTEMS to add additional hosts.${NORMAL}"
	echo "###     List of hosts in cluster" >    ${DATA_DIR}/${CLUSTER}/SYSTEMS
	echo "#       Used by markit/find-code.sh, Linux-admin/cluster-command/cluster-command.sh," >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
	echo "#       pi-display/create-message/create-display-message.sh, and other scripts." >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
	echo "###" >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
	echo "#       One FQDN or IP address on each line" >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
	echo "###" >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
	echo $(hostname -f) >> ${DATA_DIR}/${CLUSTER}/SYSTEMS
	chown ${ADMUSER}:${ADMGRP} ${DATA_DIR}/${CLUSTER}/SYSTEMS
	chmod 0664 ${DATA_DIR}/${CLUSTER}/SYSTEMS
fi

#	crontab
if [ -e /var/spool/cron/crontabs/${ADMUSER} ] ; then
	echo -e "\n\tCreating a copy of /var/spool/cron/crontabs/${ADMUSER}" 1>&2
	DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
	cp /var/spool/cron/crontabs/${ADMUSER} /var/spool/cron/crontabs/${ADMUSER}.${DATE_STAMP}
	chown ${ADMUSER}:${ADMGRP} /var/spool/cron/crontabs/${ADMUSER}.${DATE_STAMP}
	chmod 0660 /var/spool/cron/crontabs/${ADMUSER}.${DATE_STAMP}
fi
touch /var/spool/cron/crontabs/${ADMUSER}
#
echo -e "\n\tUpdating /var/spool/cron/crontabs/${ADMUSER}" 1>&2
###	Raspberry Pi with blinkt for pi-display
echo    "# DO NOT EDIT THIS FILE - edit the master and reinstall."  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# "  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# (Cron version -- $Id: crontab.c,v 2.13 1994/01/17 03:20:37 vixie Exp $)"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "#   Edit this file to introduce tasks to be run by cron."  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "#   Raspberry Pi with blinkt for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "#   Uncomment the following 7 lines on Raspberry Pi with blinkt installed for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# @reboot   /usr/local/bin/display-led-test.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# * * * * *            /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# * * * * * sleep 5  ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# * * * * * sleep 20 ; /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# * * * * * sleep 25 ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "* * * * * sleep 40 ; /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# * * * * * sleep 45 ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
###     Raspberry Pi with scroll-pHAT for pi-display
echo -e "#\n#   scroll-pHAT for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "#   Uncomment the following 3 lines and the line above which includes sleep 40 ; ... create-host-info.sh ... on Raspberry Pi with scroll-pHAT for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# @reboot   /usr/local/bin/display-scrollphat-test.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# */2 * * * *      /usr/local/bin/create-display-message.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# 1-59/2 * * * *   /usr/local/bin/display-message.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
###	Raspberry Pi with scroll-pHAT-HD for pi-display
echo -e "#\n#   scroll-pHAT-HD for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "#   Uncomment the following 3 lines and the line above which includes sleep 40 ; ... create-host-info.sh ... on Raspberry Pi with scroll-pHAT HD for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# @reboot   /usr/local/bin/display-scrollphathd-test.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# */2 * * * *      /usr/local/bin/create-display-message.sh >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# 1-59/2 * * * *   /usr/local/bin/display-message-hd.py >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
###     All Raspberry Pi's that include any above section to rotate logs for pi-display
echo -e "#\n#   All Raspberry Pi's that include any above section to rotate logs for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "#   Uncomment the following line to rotate logs for pi-display"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# 6 */2 * * * /usr/sbin/logrotate -s /usr/local/data/us-tx-cluster-1/logrotate/status /usr/local/data/us-tx-cluster-1/logrotate/pi-display-logrotate >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
###     Prometheus exporter for hardware and OS metrics exposed by *NIX kernels
echo -e "#\n#   Prometheus exporter for hardware and OS metrics exposed by *NIX kernels"  >> /var/spool/cron/crontabs/${ADMUSER}
echo    "# @reboot /usr/local/bin/node_exporter >> /usr/local/data/us-tx-cluster-1/log/`hostname -f`-crontab 2>&1"  >> /var/spool/cron/crontabs/${ADMUSER}
#
chown ${ADMUSER}:crontab /var/spool/cron/crontabs/${ADMUSER}
chmod 0600 /var/spool/cron/crontabs/${ADMUSER}
echo -e "\n\t${BOLD}Edit /var/spool/cron/crontabs/${ADMUSER} using crontab -e" 1>&2
echo -e "\tUncomment the section that is needed for your Raspberry Pi\n${NORMAL}" 1>&2

#	logrotate
#
#
### pi-display-logrotate - logrotate conf file
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
chown ${ADMUSER}:${ADMGRP} ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate
chmod 0660 ${DATA_DIR}/${CLUSTER}/logrotate/pi-display-logrotate

#	remove clone copy
#	cd ..
#	rm -rf ./pi-display/

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
