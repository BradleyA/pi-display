#!/usr/bin/env python
# 	scrollphat.test.py  3.193.335  2018-10-03_18:46:23_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.192  
# 	   updated Done statement with new standard 
# 	scrollphat.test.py  3.191.333  2018-10-03_17:12:32_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.190  
# 	   Change echo or print DEBUG INFO WARNING ERROR close #47 
#
###	scrollphat.test.py - ten second Scroll pHAT screen test
DEBUG = 0       # 0 = debug off, 1 = debug on
#
import subprocess
import sys
import time
import os
###
class color:
   BOLD = '\033[1m'
   END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
   print ("\n{} - ten second Scroll pHAT screen test".format( __file__))
   print ("\nUSAGE\n   {} [--help | -help | help | -h | h | -? | ?]".format(__file__))
   print ("   {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\nTest scrollphat pixels for ten seconds after raspberry pi boots.")
   print ("\nModified Pimoroni scroll-phat/examples/test-all.py and renamed it to")
   print ("scrollphat.test.py for Raspberry Pi.")
   print ("\nDOCUMENTATION\n    https://github.com/BradleyA/pi-display")
#  After displaying help in english check for other languages
   if LANGUAGE != "en_US.UTF-8" :
      print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Your language, {} is not supported, Would you like to help translate?".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, LANGUAGE))
#  elif LANGUAGE == "fr_CA.UTF-8" :
#     print display_help in french
#  else :
   return

#  Line number function
from inspect import currentframe
def get_line_no() :
   cf = currentframe()
   return cf.f_back.f_lineno

#  Date and time function
def get_date_stamp() :
   return time.strftime("%Y-%m-%d-%H-%M-%S-%Z")

#  Fully qualified domain name
from socket import getfqdn
#  FQDN hostname
LOCALHOST = getfqdn()

#  Version  
with open(__file__) as f :
   f.readline()
   line2 = f.readline()
   line2 = line2.split()
   SCRIPT_NAME = line2[1]
   SCRIPT_VERSION = line2[2]
   f.close()

#  Set user variables
if "LOGNAME" in os.environ : LOGNAME = os.getenv("LOGNAME") # Added three lines because USER is not defined in crobtab jobs
if "USER" in os.environ : USER = os.getenv("USER")
else : USER = LOGNAME
#
UID = os.getuid()
GID = os.getgid()
if DEBUG == 1 : print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Set user variables".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID))

#  Default help and version arguments
no_arguments =  int(len(sys.argv))
if no_arguments == 2 :
#  Default help output  
   if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?' :
      display_help()
      sys.exit()
#  Default version output  
   if sys.argv[1] == '--version' or sys.argv[1] == '-version' or sys.argv[1] == 'version' or sys.argv[1] == '-v' :
      print ("{} {}".format(SCRIPT_NAME, SCRIPT_VERSION))
      sys.exit()

#  Begin script INFO
print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Begin".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID))

#  DEBUG example
from platform import python_version
#
if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Version of python >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, python_version()))

#
import math
import scrollphat
#
scrollphat.set_brightness(1)
#
def set_checker(offset) :
   n = offset
   for y in range(5):
      for x in range(11):
         scrollphat.set_pixel(x,y,n % 2 == 0)
         n += 1
   scrollphat.update()
#
PAUSE=0.2
for count in range(8):
      scrollphat.set_pixels(lambda x, y: 1, auto_update=True)
      time.sleep(PAUSE)
      scrollphat.set_pixels(lambda x, y: y % 2 == 0, auto_update=True)
      time.sleep(PAUSE)
      scrollphat.set_pixels(lambda x, y: x % 2 == 0, auto_update=True) 
      time.sleep(PAUSE)
      set_checker(0)
      time.sleep(PAUSE)
      set_checker(1)
      time.sleep(PAUSE)
#
scrollphat.clear()
#
print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Done.".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID))
#
sys.exit(-1)
###
