#!/usr/bin/env python
# 	display-message-hd.py  3.82.196  2018-08-22_22:28:51_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.81  
# 	   format cleanup 
# 	display-message-hd.py  3.81.195  2018-08-21_23:01:44_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.80  
# 	   add more standard code #22 
# 	display-message-hd.py  3.80.194  2018-08-21_22:53:45_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.79  
# 	   begin design for display_help and line arguments using default  #22 
# 	ba-test-text.py  3.78.192  2018-08-21_22:24:06_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.77  
# 	   start design and deveopment of scrollphathd/ #22 

import time
import signal

import scrollphathd
from scrollphathd.fonts import font3x5

import sys
import os
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
#       After displaying help in english check for other languages
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
#       Check argument 1 for non-default MESSAGE file
if no_arguments == 2 :
   MESSAGE_file = sys.argv[1]
else :
#       set default MESSAGE file with path
   MESSAGE_file = "/usr/local/data/us-tx-cluster-1/MESSAGE"
   print "\n",color.END,__file__,get_line_no(),color.BOLD,"[INFO]",color.END,"Using MESSAGE file",MESSAGE_file
#	Rotate the text
scrollphathd.rotate(180)
#	Set brightness
scrollphathd.set_brightness(0.5)
# Every refresh_interval seconds we'll refresh the uptime
# Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60
#
def get_timeout():
   return ticks_per_second * refresh_interval
#
def get_msg():
   file = open(MESSAGE_file,"r")
#    print file.read()
   val = file.read()
   file.close()
#    val = subprocess.check_output(["uptime", "-p"]).decode("utf-8")
#    val = val.replace("\n","")
   val = val + " ---->  "
   return val
#
while True:
   scrollphathd.write_string( get_msg(), x=0, y=1, font=font3x5, brightness=0.5)
   scrollphathd.show()
   scrollphathd.scroll()
   time.sleep(0.05)

