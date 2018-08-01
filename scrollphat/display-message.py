#!/usr/bin/env python
# 	display-message.py  3.70.183  2018-07-31_22:49:15_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.69  
# 	   debug completd first pass, add to crontab for more testing #19 #13 
# 	display-message.py  3.68.181  2018-07-31_22:22:04_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.67-2-gcfd104d  
# 	   completed merge of display-message.py and help-message.py #19 #13 
# 	display-message.py  3.67.178  2018-07-31_22:09:20_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.66  
# 	   first pass of merge help-message.py with display-message.py #19 #13 
# 	help-message.py  3.66.177  2018-07-29_23:02:16_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.65  
# 	   completed aargument design close #15 updated code for #18 
# 	help-message.py  3.65.176  2018-07-29_21:56:49_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.64  
# 	   added LANG support for display_help 
# 	help-message.py  3.64.175  2018-07-29_20:51:00_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.63  
# 	   test works --version -version version -v #15 
# 	help-message.py  3.63.174  2018-07-29_19:11:04_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.62  
# 	   test works for --help -help help -h h -? ? #15 
# 	help-message.py  3.62.173  2018-07-29_19:07:08_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.61  
# 	   test works for --help -help help -h h -? ? 
# 	help-message.py  3.61.172  2018-07-29_17:35:05_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.60  
# 	   cleanup file after completing #18 to continue with #19 
# 	help-message.py  3.60.171  2018-07-29_17:25:31_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.59  
# 	   Completed design of ERROR WARNING INFO message for python close #18 
# 	display-message.py  3.59.170  2018-07-29_13:30:07_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.58  
# 	   getting close with #18 ERROR WARNING INFO stdout:wq 
# 	help-message.py  3.57.168  2018-07-28_15:42:23_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.56  
# 	   test works -h  does not work --help -help help h -? ? #15 
# 	help-message.py  3.56.167  2018-07-28_14:59:59_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.55-1-gff92252  
# 	   begin design on py help processing 
# 	display-message.py  3.54.164  2018-07-27_20:13:51_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.53  
# 	   change default directory to /usr/local/data/us-tx-cluster-1 
# 	display-message.py  3.45.154  2018-07-18_22:09:28_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.44-2-g4df6d1b  
# 	   begin design for display_help and line arguments using default 
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
