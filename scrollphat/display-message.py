#!/usr/bin/env python
# 	display-message.py  3.112.254  2018-09-15_21:58:47_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.111  
# 	   DEBUG, comments, print pythom3 
# 	display-message.py  3.84.198  2018-08-26_22:32:55_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.83  
# 	   display-help 
# 	display-message.py  3.71.184  2018-07-31_22:58:30_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.70  
# 	   completed adding help-message.py code into display-message.py close #19 
###
DEBUG = 1       # 0 = debug off, 1 = debug on
#
import subprocess
import sys
import time
import os
import scrollphat
###
class color:
   BOLD = '\033[1m'
   END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
   print ("\n{} - <one line description>".format( __file__))
   print ("\nUSAGE\n   {} [xxx | yyy | zzz]".format(__file__))
   print ("   {} [--help | -help | help | -h | h | -? | ?]".format(__file__))
   print ("   {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\n<<your help output goes here>>")
   print ("\nOPTIONS\n   <<your options go here>>")
   print ("\nDOCUMENTATION\n   <<URL to GITHUB README>>")
   print ("\nEXAMPLES\n   <<your code examples description goes here>>")
   print ("   {} <<code example goes here>>\n".format(__file__))
#  After displaying help in english check for other languages
   if LANGUAGE != "en_US.UTF-8" :
      print ("{}{} {} {}[WARNING]{}  {}  Your language, {} is not supported, Would you like to help?".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_time_stamp(), LANGUAGE))
#  elif LANGUAGE != "fr_CA.UTF-8" :
#     print display_help in french
#  else :
   return

#  Line number function
from inspect import currentframe
def get_line_no():
   cf = currentframe()
   return cf.f_back.f_lineno

#  date and time function
def get_time_stamp():
   return time.strftime("%Y-%m-%d-%H-%M-%S-%Z")

#  Default help and version arguments
no_arguments =  int(len(sys.argv))
if no_arguments == 2 :
#  Default help output  
   if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?' or sys.argv[1] == '?' :
      display_help()
      sys.exit()
#  Default version output  
   if sys.argv[1] == '--version' or sys.argv[1] == '-version' or sys.argv[1] == 'version' or sys.argv[1] == '-v' :
      with open(__file__) as f:
         f.readline()
         line2 = f.readline()
         line2 = line2.split()
         print ("{} {}".format(line2[1], line2[2]))
      sys.exit()

#  DEBUG example
if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Name_of_command >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), __file__))

#  Check if there is an argument after command if TRUE use the argument to replace MESSAGE filename else use default MESSAGE
# >>>   needs testing
if no_arguments == 2 :
#  Set non-default MESSAGE file with path
   MESSAGE_FILE = sys.argv[1]
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))
else :
#  Set default MESSAGE file with path
   MESSAGE_FILE = "/usr/local/data/us-tx-cluster-1/MESSAGE"
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))

#  Set brightness
scrollphat.set_brightness(4)
# Every refresh_interval seconds we'll refresh the uptime
# Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60

#  timeout
def get_timeout():
   return ticks_per_second * refresh_interval

#  Read MESSAGE_FILE contents and return contents
def get_msg() :
   file = open(MESSAGE_FILE,"r")
   val = file.read()
   file.close()
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
#	 display_help()
      else:
         count = count+ 1
   except KeyboardInterrupt:
      scrollphat.clear()
      sys.exit(-1)
###
