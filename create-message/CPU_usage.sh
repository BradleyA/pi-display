#!/bin/bash
# 	CPU_usage.sh  3.210.352  2018-10-14T13:21:10-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.209  
# 	   complete testing for now #37 
#
###	CPU_usage.sh
DEBUG=0                 # 0 = debug off, 1 = debug on
#       set -x
#       set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - >>> NEED TO COMPLETE THIS SOON, ONCE I KNOW HOW IT IS GOING TO WORK :-) <<<"
echo -e "\nUSAGE\n   ${0}"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nXXXXXX "
echo -e "\nOPTIONS "
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-scripts/tree/master/cpu-temperature"
echo -e "\nEXAMPLES\n   XXXXXX \n\t${0} XXXXXX\n"
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARNING${NORMAL}]:     Your language, ${LANG}, is not supported.\n\tWould you like to help?\n" 1>&2
fi
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
if [ "${DEBUG}" == "1" ] ; then echo -e "> DEBUG ${LINENO}  >${0}<  >${1}<" 1>&2 ; fi

cpu_now=($(head -n1 /proc/stat)) ;
cpu_sum="${cpu_now[@]:1}" ;
cpu_sum=$((${cpu_sum// /+})) ;
cpu_last=("${cpu_now[@]}") ;
cpu_last_sum=$cpu_sum ;

sleep 1 ;

cpu_now=($(head -n1 /proc/stat)) ;
cpu_sum="${cpu_now[@]:1}" ;
cpu_sum=$((${cpu_sum// /+})) ;
cpu_delta=$((cpu_sum - cpu_last_sum + 1)) ;
cpu_idle=$((cpu_now[4]- cpu_last[4])) ;
cpu_used=$((cpu_delta - cpu_idle)) ;
cpu_usage=$((100 * cpu_used / cpu_delta + 1)) ;

echo "CPU_USAGE: "${cpu_usage} ;
