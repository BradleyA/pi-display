#!/bin/bash
# 	setup-display.sh  3.274.448  2019-01-04T13:34:08.562046-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.273-11-gf99f687  
# 	   update display_help 
# 	setup-display.sh  3.269.428  2019-01-03T14:42:35.499629-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.268  
# 	   start creating setup for pi-display 
#
### setup-display.sh
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
echo    "pi-display/create-message/create-message.sh, and other scripts."
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


###
mkdir -p /usr/local/data/<CLUSTER>
mkdir -p /usr/local/data/<CLUSTER>/log
mkdir -p /usr/local/data/<CLUSTER>/logrotate
###
