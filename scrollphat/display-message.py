#!/usr/bin/env python
# 	display-message.py  3.71.184  2018-07-31_22:58:30_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.70  
# 	   completed adding help-message.py code into display-message.py close #19 
###
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
def display_help():
   language = os.getenv("LANG")
   print "\n", __file__, "- <one line description>"
   print "\nUSAGE\n  ", __file__, "[xxx | yyy | zzz]"
   print "  ", __file__, "[--help | -help | help | -h | h | -? | ?] [--version | -v]"
   print "\nDESCRIPTION\n<<your help output goes here>>"
   print "\nOPTIONS\n   <<your options go here>>"
   print "\nDOCUMENTATION\n   <<URL to GITHUB README>>"
   print "\nEXAMPLES\n   <<your code examples go here>>"
   print "      <<line two of first example>>"
#	After displaying help in english check for other languages
   if language != "en_US.UTF-8" :
      print color.END,__file__,get_line_no(),color.BOLD,"[WARNING]",color.END,"Your language,", language, "is not supported, Would you like to help?"
   return
#
from inspect import currentframe
def get_line_no():
    cf = currentframe()
    return cf.f_back.f_lineno
#
no_arguments =  int(len(sys.argv))
if no_arguments == 2 :
   if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?' or sys.argv[1] == '?' :
      display_help()
      sys.exit()
   if sys.argv[1] == '--version' or sys.argv[1] == '-version' or sys.argv[1] == 'version' or sys.argv[1] == '-v' :
      with open(__file__) as f:
         f.readline()
         line2 = f.readline()
         line2 = line2.split()
         print line2[1], line2[2]
      sys.exit()
#	Check argument 1 for non-default MESSAGE file
if no_arguments == 2 :
   MESSAGE_file = sys.argv[1]
else :
#	set default MESSAGE file with path
   MESSAGE_file = "/usr/local/data/us-tx-cluster-1/MESSAGE"
print "\n",color.END,__file__,get_line_no(),color.BOLD,"[INFO]",color.END,"Using MESSAGE file",MESSAGE_file
#
scrollphat.set_brightness(4)
# Every refresh_interval seconds we'll refresh the uptime
# Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60

def get_timeout():
   return ticks_per_second * refresh_interval

def get_msg():
   file = open(MESSAGE_file,"r")
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
#	 display_help()
      else:
         count = count+ 1
   except KeyboardInterrupt:
      scrollphat.clear()
      sys.exit(-1)
###
