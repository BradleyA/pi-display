#!/bin/bash
# 	create-message.sh	2.4.33	2018-02-26_17:06:02_CST uadmin three-rpi3b.cptx86.com 2.3 
# 	   rewrote uptime todisplay-board.py 
# 	display-board-1.sh	2.3.32	2018-02-26_15:14:25_CST uadmin three-rpi3b.cptx86.com 2.2-9-gfd85103 
# 	   continue debug; remove debug echo, add -q to ssh and scp 
# 	display-board-1.sh	2.2.22	2018-02-25_18:48:57_CST uadmin three-rpi3b.cptx86.com 2.1 
# 	   add file and directory checks 
# 	display-board-1.sh	2.1.21	2018-02-25_12:07:56_CST uadmin three-rpi3b.cptx86.com 1.2-1-g87d879f 
# 	   change design to do all the work but don't know how to fork the process and the kill -9 the fork 
# 	display-board-1.sh	1.2.19	2018-02-24_21:19:39_CST uadmin three-rpi3b.cptx86.com 1.1 
# 	   more cleanup 
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
echo    "   UNDER DEVELOPMENT  . . . .  ."
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
CLUSTER=${1:-cluster-1/}
USER=${2:-${USER}}
DATA_DIR=${3:-/usr/local/data/}
SSHPORT=${4:-22}
CONTAINERS=0
RUNNING=0
PAUSED=0
STOPPED=0
IMAGES=0
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
LOCALHOST=`hostname -f`
###
#       Check if cluster directory on system
if [ ! -d ${DATA_DIR}${CLUSTER} ] ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:\tCreating missing directory: ${DATA_DIR}${CLUSTER}\n" 1>&2
	mkdir -p  ${DATA_DIR}${CLUSTER}
fi
#       Check if SYSTEMS file on system
#	one FQDN per line for all hosts in cluster
if ! [ -e ${DATA_DIR}${CLUSTER}/SYSTEMS ] ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:\tSYSTEMS file missing, creating SYSTEMS file with local host.\n" 1>&2
	echo -e "\tAdd hosts that are in cluster into file."
	hostname -f > ${DATA_DIR}${CLUSTER}/SYSTEMS
fi
#	Create missing host files from list in SYSTEM file
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS) ; do
	touch ${DATA_DIR}${CLUSTER}/${NODE}
done
#
NODE_LIST=`find ${DATA_DIR}${CLUSTER} -type f ! -name SYSTEMS ! -name MESSAGE -print`
#       Check if ${NODE_LIST} is zero length
if [ -z "${NODE_LIST}" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:      No file(s) found\n" 1>&2
	echo -e "\tCheck to make sure user has permission to create directory and files."
	exit 1
fi
for NODE in ${NODE_LIST} ; do
#	Check if ${NODE##*/} is ${LOCALHOST} don't use ssh and scp
	if [ "${LOCALHOST}" != "${NODE##*/}" ] ; then
#	Check if ${NODE} is available on port ${SSHPORT}
		if $(nc -z ${NODE##*/} ${SSHPORT} >/dev/null) ; then
			TEMP="docker system info | head -5 > ${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa -p ${SSHPORT} ${USER}@${NODE##*/} ${TEMP}
			scp -q    -i ~/.ssh/id_rsa -P ${SSHPORT} ${USER}@${NODE##*/}:${NODE} ${DATA_DIR}${CLUSTER}
		else
			echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:        ${NODE##*/} not responding on port ${SSHPORT}.\n"   1>&2
		fi
	else
		docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${LOCALHOST}
	fi
	CONTAINERS=`grep -i CONTAINERS ${NODE} | awk -v v=$CONTAINERS '{print $2 + v}'`
	RUNNING=`grep -i RUNNING ${NODE} | awk -v v=$RUNNING '{print $2 + v}'`
	PAUSED=`grep -i PAUSED ${NODE} | awk -v v=$PAUSED '{print $2 + v}'`
	STOPPED=`grep -i STOPPED ${NODE} | awk -v v=$STOPPED '{print $2 + v}'`
	IMAGES=`grep -i IMAGES ${NODE} | awk -v v=$IMAGES '{print $2 + v}'`
done
#	echo    "${0} ${LINENO} -->${LOCALHOST}<--->${NODE##*/}<--->${SSHPORT}<--->${USER}<--"
#	echo    "${0} ${LINENO} -->${CONTAINERS}<--->${RUNNING}<--->${PAUSED}<---->${STOPPED}<---->${IMAGES}<----"
#	echo    "${0} ${LINENO} -->${LOCALHOST}<--n-->${NODE}<--dd-->${DATA_DIR}<--c-->${CLUSTER}<--P-->${SSHPORT}<--U-->${USER}<--"
#	echo ${MESSAGE} > ${DATA_DIR}${CLUSTER}/MESSAGE
MESSAGE=" CONTAINERS ${CONTAINERS}  RUNNING ${RUNNING}  PAUSED ${PAUSED}  STOPPED ${STOPPED}  IMAGES ${IMAGES} "
echo ${MESSAGE} > ${DATA_DIR}${CLUSTER}/MESSAGE
./scroll-text-rotated.py "${MESSAGE}"
###
