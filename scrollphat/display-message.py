#!/usr/bin/env python
# 	display-message.py  3.56.167  2018-07-28_14:59:59_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.55-1-gff92252  
# 	   begin design on py help processing 
# 	display-message.py  3.54.164  2018-07-27_20:13:51_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.53  
# 	   change default directory to /usr/local/data/us-tx-cluster-1 
# 	display-message.py  3.45.154  2018-07-18_22:09:28_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.44-2-g4df6d1b  
# 	   begin design for display_help and line arguments using default 

###
import subprocess
import sys
import time

import scrollphat

def display_help():
    print("<<your help output goes here>>")
#	need to change to python from bash echo -e "\n${0} - remote cluster system adminstration tool"
    sys.exit(1)

print("""
Currently using /usr/local/data/us-tx-cluster-1/MESSAGE
Need to change to argument and have a default location

Press Ctrl+C to exit!

""")

#	review github incident #15
print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)
###	if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
###	        display_help
###	        exit 0
###	fi
###	if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] ||  [ "$1" == "-v" ] ; then
###	        head -2 ${0} | awk {'print$2"\t"$3'}
###	        exit 0
###	fi


scrollphat.set_brightness(4)

# Every refresh_interval seconds we'll refresh the uptime
# Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60

def get_timeout():
    return ticks_per_second * refresh_interval

def get_msg():
    file = open("/usr/local/data/us-tx-cluster-1/MESSAGE","r")
#    print file.read()
    val = file.read()
    file.close()
#    val = subprocess.check_output(["uptime", "-p"]).decode("utf-8")
#    val = val.replace("\n","")
    val = val + " ---->  "
    return val

timeout = get_timeout()
count = 0
msg = get_msg()
scrollphat.set_rotate(True)
scrollphat.write_string(msg)

while True:
    try:
        scrollphat.scroll()
        time.sleep(pause)

        if(count > timeout):
            msg = get_msg()
            scrollphat.write_string(msg)
            timeout = get_timeout()
            count = 0
#		incident #13

            print ("Updating uptime message")
#	            display_help()
        else:
            count = count+ 1
    except KeyboardInterrupt:
        scrollphat.clear()
        sys.exit(-1)

