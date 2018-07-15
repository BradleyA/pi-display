#!/bin/bash
# 	CPU_usage.sh  3.36.143  2018-07-15_13:01:07_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.35  
# 	   got remote CPU usage working now need to add code for local 
# 	CPU_usage.sh  3.35.142  2018-07-15_12:46:16_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.34  
# 	   add CPU_usage.sh script to solve this fucking incident with * 

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

echo "CPU_usage: "${cpu_usage} ;
