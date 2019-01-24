#!/usr/bin/env python3
# 	blinkt/display-led-test.py  3.374.570  2019-01-23T22:16:37.530539-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.373  
# 	   blinkt/display-led-test.py update with --> production standard 1-5 include Copyright notice close #67 
# 	blinkt/display-led-test.py  3.373.569  2019-01-23T21:51:47.651894-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.372-6-g8d92fb5  
# 	   second pass to add production standards 
# 	blinkt/display-led-test.py  3.372.562  2019-01-23T21:36:59.212435-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.371  
# 	   first pass to add production standards 
# 	blinkt/display-led-test.py  3.371.561  2019-01-23T21:13:33.503303-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.370  
# 	   adjust timimg 
# 	blinkt/display-led-test.py  3.369.559  2019-01-23T20:42:21.093603-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.368  
# 	   added led color test during start 
# 	blinkt/display-led-test.py  3.271.430  2019-01-03T14:49:30.532723-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.270  
# 	   rename scrollphat.test.py to display-scrollphat-test.py 
# 	larson-1.py  3.175.317  2018-09-29_21:47:03_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.174  
# 	   add green after red 
# 	larson-1.py  3.174.316  2018-09-29_21:36:57_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.173  
# 	   include larson-1.py 
### display-led-test.py - from larson.py
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#   production standard 5
import sys
import datetime
import time
import os
import math
import colorsys
from blinkt import set_clear_on_exit, set_pixel, show, set_brightness
#       Order of precedence: environment variable (export DEBUG=1), default code
DEBUG = int(os.getenv("DEBUG", 0)) #  Set DEBUG,  0 = debug off, 1 = debug on, 'unset DEBUG' to unset environment variable (bash)
###
class color:
    BOLD = '\033[1m'
    END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
    print("\n{} - Test leds".format(__file__))
    print("\nUSAGE\n   {}".format(__file__))
    print("   {} [--help | -help | help | -h | h | -?]".format(__file__))
    print("   {} [--version | -version | -v]".format(__file__))
    print("\nDESCRIPTION")
#   Displaying help DESCRIPTION in English en_US.UTF-8
    print("This script tests the leds during system boot.  The script can be run on the")
    print("command line.  It is designed to be run fron crontab during system boot.  It")
    print("is configured using, crontab -e")
#       Displaying help DESCRIPTION in French
    if (LANGUAGE == "fr_CA.UTF-8") or (LANGUAGE == "fr_FR.UTF-8") or (LANGUAGE == "fr_CH.UTF-8"):
        print("\n--> {}".format(LANGUAGE))
        print("<votre aide va ici>")
        print("Souhaitez-vous traduire la section description?")
    elif (LANGUAGE != "en_US.UTF-8"):
        print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  {} is not supported, Would you like to help translate the description section?".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, LANGUAGE))
    print("\nEnvironment Variables")
    print("If using the bash shell, enter; 'export DEBUG=1' on the command line to set")
    print("the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the")
    print("command, 'unset DEBUG' to remove the exported information from the DEBUG")
    print("environment variable.  You are on your own defining environment variables if")
    print("you are using other shells.")
    print("   DEBUG       (default '0')")
    print("\nDOCUMENTATION\n    https://github.com/BradleyA/pi-display/tree/master/blinkt")
    return

#   Line number function
from inspect import currentframe
def get_line_no():
    cf = currentframe()
    return cf.f_back.f_lineno

#   Date and time function ISO 8601
def get_date_stamp():
    # calculate the offset taking into account daylight saving time
    utc_offset_sec = time.altzone if time.localtime().tm_isdst else time.timezone
    utc_offset = datetime.timedelta(seconds=-utc_offset_sec)
    ISO8601 = datetime.datetime.now().replace(tzinfo=datetime.timezone(offset=utc_offset)).isoformat()  + time.strftime(" (%Z)")
#   ISO8601 = time.strftime("%Y-%m-%dT%H:%M:%S%z") + time.strftime(" (%Z)") # previous solution
    return ISO8601

#   Fully qualified domain name
from socket import getfqdn
#   FQDN hostname
LOCALHOST = getfqdn()

#   Version
with open(__file__) as f:
    f.readline()
    line2 = f.readline()
    line2 = line2.split()
    SCRIPT_NAME = line2[1]
    SCRIPT_VERSION = line2[2]
    f.close()

#   Set user variables
if "LOGNAME" in os.environ: LOGNAME = os.getenv("LOGNAME") # Added three lines because USER is not defined in crobtab jobs
if "USER" in os.environ: USER = os.getenv("USER")
else: USER = LOGNAME
#
UID = os.getuid()
GID = os.getgid()
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Setting USER to support crobtab...".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))

#   Default help and version arguments
no_arguments = int(len(sys.argv))
if no_arguments == 2:
#   Default help output
    if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?':
        display_help()
        sys.exit()
#   Default version output
    if sys.argv[1] == '--version' or sys.argv[1] == '-version' or sys.argv[1] == 'version' or sys.argv[1] == '-v':
        print("{} {}".format(SCRIPT_NAME, SCRIPT_VERSION))
        sys.exit()

#   Begin script INFO
print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  Started...".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))

#   DEBUG example
from platform import python_version
#
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Version of python >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, python_version()))

###
set_clear_on_exit()
reds = [0, 0, 0, 0, 0, 16, 64, 255, 64, 16, 0, 0, 0, 0, 0]
start_time = time.time()

#   Red
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Test Red led".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
for count in range(83):
    delta = (time.time() - start_time) * 16
    offset = int(abs((delta % 16) - 8))
    for i in range(8):
        set_pixel(i , reds[offset + i], 0, 0)
    show()
    time.sleep(0.1)

#   Green
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Test Green led".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
for count in range(37):
    delta = (time.time() - start_time) * 16
    offset = int(abs((delta % 16) - 8))
    for i in range(8):
        set_pixel(i , 0, reds[offset + i], 0)
    show()
    time.sleep(0.1)

#   Rainbow
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Test Rainbow led".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
set_brightness(0.1)
spacing = 360.0 / 16.0
hue = 0
x = 0
j = 1
#
for j in range(2300):
    hue = int(time.time() * 100) % 360
    for x in range(8):
        offset = x * spacing
        h = ((hue + offset) % 360) / 360.0
        r, g, b = [int(c * 255) for c in colorsys.hsv_to_rgb(h, 1.0, 1.0)]
        set_pixel(x, r, g, b)
    show()
    time.sleep(0.001)

#   Done
print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  Operation finished.".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
###
