#!/bin/bash
# 	cpu-temperature/cpu-temperature.sh  2.8.47  2018-02-28_12:46:40_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.7-7-gca0e0da  
# 	   moved cpu-temperature and syste-stats project into this repository 
# 	cpu-temperature/cpu-temperature.sh  2.8.46  2018-02-28_12:43:05_CST  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 2.7-6-g7238272  
# 	   moved cpu-temperature and syste-stats project into this repository 
# 	cpu-temperature.sh	1.4.34	2018-02-21_21:22:51_CST uadmin six-rpi3b.cptx86.com 1.3 
# 	   ruff draft addition display_help cpu-temperature.sh & system-stats-1.sh 
#	cpu-temperature.sh	1.0	2017-12-20_22:07:09_CST uadmin rpi3b-two.cptx86.com
#	added description comment and added mark
#
#       set -x
#       set -v
#
#	print out current temperature
###             
display_help() {
echo -e "\n${0} - >>> NEED TO COMPLETE THIS SOON, ONCE I KNOW HOW IT IS GOING TO WORK :-) <<<"
echo -e "\nUSAGE\n   ${0}"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nXXXXXX "
echo -e "\nOPTIONS "
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-scripts/tree/master/cpu-temperature"
echo -e "\nEXAMPLES\n   XXXXXX \n\t${0} XXXXXX\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] ||  [ "$1" == "version" ]  ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###
echo "Hostname =	" `hostname`

CPUTEMP=$(/usr/bin/vcgencmd measure_temp | \
sed -e 's/?C$//' | \
sed -e 's/temp=//')

CPUTEMP=${CPUTEMP//\'C/}

echo "Celsius =	" $CPUTEMP
echo $CPUTEMP | awk '{print "Fahrenheit =	" 1.8 * $1 +32}'
