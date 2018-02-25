#!/bin/bash
# 	docker-client-status.sh	2.1.21	2018-02-25_12:07:56_CST uadmin three-rpi3b.cptx86.com 1.2-1-g87d879f 
# 	   change design to do all the work but don't know how to fork the process and the kill -9 the fork 
#
#	set -x
#	set -v
###
display_help() {
echo -e "\n${0} - display display container status"
echo    "   UNDER DEVELOPMENT to add REMOTEHOST.  Currently works for local host only."
echo -e "\nUSAGE\n   ${0}"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nThis script "
echo -e "\nOPTIONS"
echo    "   arg1	XXXXXX"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/display-board-2-project"
echo -e "\nEXAMPLES\n   xxxxxxxx "
echo -e "   xxxxxXXXXxxxxXXXX, x\n\tsudo ${0}\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] || [ "$1" == "version" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
### 
CLUSTER=${1:-docker-cluster-1}
DISPLAY_HOST=${2:-three-rpi3b}
DATA_DIR=${3:-/usr/local/data/}
HOSTNAME=`hostname`
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
# >>>	write to file in ${DATA_DIR}${CLUSTER}/${HOSTNAME}
#		mkdir -p  ${DATA_DIR}${CLUSTER}
#		docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${HOSTNAME}
#	Copy file to scroll-display
#		echo "copy file"
#	scp -i ~/.ssh/id_rsa ${DATA_DIR}${CLUSTER}/${HOSTNAME} uadmin@`hostname -f`:${DATA_DIR}${CLUSTER}
scp -i ~/.ssh/id_rsa uadmin@one-rpi3b.cptx86.com:${DATA_DIR}${CLUSTER}/one-rpi3b ${DATA_DIR}${CLUSTER}
###
