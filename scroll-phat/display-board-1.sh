#!/bin/bash
# 	display-board-1.sh	1.1.18	2018-02-24_21:17:17_CST uadmin three-rpi3b.cptx86.com v0.2-14-g1976579 
# 	   cleanup code from a day of debug 
# 	display-board-1.sh	1.0.13	2018-02-24_20:39:37_CST uadmin three-rpi3b.cptx86.com v0.2-9-g61e9ec1 
# 	   first working draft from flat files 
#	ba-message1	1.0	2017-12-20_21:07:44_CST uadmin rpi3b-three.cptx86.com
#	mark initial version
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
DATA_DIR=${2:-/usr/local/data/}
CONTAINERS=0
RUNNING=10
PAUSED=100
STOPPED=1000
IMAGES=10000
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
# >>>	write to file in ${DATA_DIR}${CLUSTER}/${HOSTNAME}
#	HOSTNAME=`hostname`
#	docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${HOSTNAME}
#	MESSAGE1=`cat ${DATA_DIR}${CLUSTER}/${HOSTNAME}`
#	echo "$MESSAGE1"
###
mkdir -p  ${DATA_DIR}${CLUSTER}
FILE_LIST=`find ${DATA_DIR}${CLUSTER} -type f ! -name TOTAL -print`
#       Check if ${FILE_LIST} is zero length
if [ -z "${FILE_LIST}" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:      No file(s) found\n" 1>&2
	exit 1
fi
for FILE_NAME in ${FILE_LIST} ; do
	CONTAINERS=`grep -i CONTAINERS ${FILE_NAME} | awk -v v=$CONTAINERS '{print $2 + v}'`
	RUNNING=`grep -i RUNNING ${FILE_NAME} | awk -v v=$RUNNING '{print $2 + v}'`
	PAUSED=`grep -i PAUSED ${FILE_NAME} | awk -v v=$PAUSED '{print $2 + v}'`
	STOPPED=`grep -i STOPPED ${FILE_NAME} | awk -v v=$STOPPED '{print $2 + v}'`
	IMAGES=`grep -i IMAGES ${FILE_NAME} | awk -v v=$IMAGES '{print $2 + v}'`
done
echo    "${0} ${LINENO} ---->${CONTAINERS}< --->${RUNNING}<--->${PAUSED}<---->${STOPPED}<---->${IMAGES}<----"
MESSAGE1=" CONTAINERS ${CONTAINERS}   RUNNING ${RUNNING}  PAUSED ${PAUSED}   STOPPED ${STOPPED}   IMAGES ${IMAGES}  "
./scroll-text-rotated.py "${MESSAGE1}"
###
