#!/usr/bin/env python
# 	display-message-hd.py  3.89.212  2018-09-01_19:21:03_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.88-9-gb961ab4  
# 	   complete display-help 
# 	../scrollphathd/display-message-hd.py  3.84.198  2018-08-26_22:32:55_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.83  
# 	   display-help 
# 	../scrollphathd/display-message-hd.py  3.83.197  2018-08-26_10:39:09_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.82  
# 	   few changes to display-help create-message.sh 
# 	display-message-hd.py  3.81.195  2018-08-21_23:01:44_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.80  
# 	   add more standard code #22 
###
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
   print "\n", __file__, "- display contents of MESSAGE file"
   print "\nUSAGE\n  ", __file__
   print "  ", __file__, "[--help | -help | help | -h | h | -? | ?]"
   print "  ", __file__, "[--version | -version | -v]"
   print "\nDESCRIPTION\nDisplay the contents of /usr/local/data/<cluster-name>/MESSAGE file on a"
   print "Scroll-pHAT-HD.  The MESSAGE file includes the total number of containers,"
   print "running containers, paused containers, stopped containers, and number of"
   print "images in the cluster.  The MESSAGE file is used by a Raspberry Pi Scroll-pHAT"
   print "or Scroll-pHAT-HD to display the current information.  The MESSAGE file is"
   print "created by create-message.sh script.  The create-message.sh script reads the"
   print "/usr/local/data/<cluster-name>/SYSTEMS file for the FQDN or IP address of the"
   print "hosts in a cluster."
   print "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/scrollphathd\n"
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
   val = " ---->  " + val
   return val
#
while True:
   scrollphathd.write_string( get_msg(), x=0, y=1, font=font3x5, brightness=0.5)
   scrollphathd.show()
   scrollphathd.scroll()
   time.sleep(0.05)

