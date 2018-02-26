#!/usr/bin/env python
# 	display-message.py	2.4.33	2018-02-26_17:06:02_CST uadmin three-rpi3b.cptx86.com 2.3 
# 	   rewrote uptime todisplay-board.py 
# 	uptime.py	2.3.32	2018-02-26_15:14:25_CST uadmin three-rpi3b.cptx86.com 2.2-9-gfd85103 
# 	   continue debug; remove debug echo, add -q to ssh and scp 


import subprocess
import sys
import time

import scrollphat


scrollphat.set_brightness(4)

# Every refresh_interval seconds we'll refresh the uptime
# Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60

def get_timeout():
    return ticks_per_second * refresh_interval

def get_msg():
    file = open("/usr/local/data/cluster-1/MESSAGE","r")
#    print file.read()
    val = file.read()
    file.close()
#    val = subprocess.check_output(["uptime", "-p"]).decode("utf-8")
#    val = val.replace("\n","")
    val = val + " ------->  "
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
            print ("Updating uptime message")
        else:
            count = count+ 1
    except KeyboardInterrupt:
        scrollphat.clear()
        sys.exit(-1)

