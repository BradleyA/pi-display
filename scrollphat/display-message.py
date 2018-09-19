#!/usr/bin/env python
# 	display-message.py  3.121.263  2018-09-18_22:14:22_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.120  
# 	   code design for environmental variables 
# 	display-message.py  3.120.262  2018-09-18_15:39:06_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.119  
# 	   remove else from import errors, add MESSAGE variables 
# 	display-message.py  3.115.257  2018-09-15_22:46:59_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.114  
# 	   + 2 count 
###
DEBUG = 1       # 0 = debug off, 1 = debug on
#
import subprocess
import sys
import time
import os
###
class color :
   BOLD = '\033[1m'
   END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help() :
   print ("\n{} - display contents of MESSAGE file".format( __file__))
   print ("\nUSAGE\n   {} [<MESSAGE_FILE>]".format(__file__))
   print ("   {} [--help | -help | help | -h | h | -? | ?]".format(__file__))
   print ("   {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\nDisplay the contents of /usr/local/data/us-tx-cluster-1/MESSAGE file on a")
   print ("Scroll-pHAT.  The MESSAGE file includes the total number of containers,")
   print ("running containers, paused containers, stopped containers, and number of")
   print ("images in the cluster.  The MESSAGE file is used by a Raspberry Pi Scroll-pHAT")
   print ("to display the current information.  The MESSAGE file is created by")
   print ("create-message.sh script.  The create-message.sh script reads the")
   print ("/usr/local/data/us-tx-cluster-1/SYSTEMS file for the FQDN or IP address of the")
   print ("hosts in a cluster.")
   print ("\nTo display the contents of a different file than the defualt file.  Enter")
   print ("the file name with the absolute path to its location as an option to")
   print ("{}.".format(__file__))
# >>>	3   environment variables needs to be added in display-help
   print ("\nOPTIONS\n   MESSAGE_FILE - alternate message file,")
   print ("                  defualt /usr/local/data/us-tx-cluster-1/MESSAGE")
   print ("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/scrollphat")
   print ("\nEXAMPLES\n   Display contents of a different file")
   print ("\n   {} /tmp/DIFFERENT_MESSAGE\n".format(__file__))
#  After displaying help in english check for other languages
   if LANGUAGE != "en_US.UTF-8" :
      print ("{}{} {} {}[WARNING]{}  {}  Your language, {} is not supported, Would you like to help?".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_time_stamp(), LANGUAGE))
#  elif LANGUAGE != "fr_CA.UTF-8" :
#     print display_help in french
#  else :
   return

#  Line number function
from inspect import currentframe
def get_line_no() :
   cf = currentframe()
   return cf.f_back.f_lineno

#  date and time function
def get_time_stamp() :
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
      with open(__file__) as f :
         f.readline()
         line2 = f.readline()
         line2 = line2.split()
         print ("{} {}".format(line2[1], line2[2]))
      sys.exit()

#  DEBUG example
import platform
if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Name of command >{}<  Version of python >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), __file__, platform.python_version()))

#  
# >>>	import scrollphat
try :
   import scrollphat 
except ImportError :
   if sys.version_info[0] < 3 :
      sys.exit("\n{}{} {} {}[ERROR]{}  {}  This library requires python-scrollphat. To install:\n\tsudo apt-get install python-scrollphat".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_time_stamp()))
# >>>	org      sys.exit("This library requires python-smbus\nInstall with: sudo apt-get install python-smbus")
   elif sys.version_info[0] == 3 :
      sys.exit("\n{}{} {} {}[ERROR]{}  {}  This library requires python3-scrollphat. To install:\n\tsudo apt-get install python3-scrollphat".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_time_stamp()))
except IOError :
      sys.exit("\n{}{} {} {}[ERROR]{}  {}  No such file or directory . is the hat not installed on raspberry pi . . not sure what this is. . . missing the scrollphat ?".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_time_stamp()))

#  Check if there is an argument after command if TRUE use the argument to replace MESSAGE filename else use default MESSAGE
# >>>   needs testing
if os.environ.has_key("DATA_DIR") :
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  DATA_DIR set with environment variable >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), DATA_DIR))
else
#  Set DATA_DIR with default
   DATA_DIR = "/usr/local/data/"
if os.environ.has_key("CLUSTER") :
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  CLUSTER set with environment variable >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), CLUSTER))
else
#  Set CLUSTER with default
   CLUSTER = "us-tx-cluster-1/"
if os.environ.has_key("MESSAGE_FILE") :
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  MESSAGE_FILE set with environment variable >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))
else
#  Set MESSAGE_FILE with default
   MESSAGE_FILE = "MESSAGE"
MESSAGE = DATA_DIR + CLUSTER + MESSAGE_FILE
if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Set default MESSAGE_FILE >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))
#
if no_arguments == 2 :
#  Set non-default MESSAGE file with path
   MESSAGE_FILE = sys.argv[1]
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))
else :
#  Set default MESSAGE file with path
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))

#  Set brightness
scrollphat.set_brightness(4)
# Every refresh_interval seconds we'll refresh
# Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60

#  timeout
def get_timeout() :
   return ticks_per_second * refresh_interval

#  Read MESSAGE_FILE contents and return contents
def get_msg() :
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Reading MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))
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

while True :
   try :
      scrollphat.scroll()
      time.sleep(pause)

      if (count > timeout) :
         msg = get_msg()
         if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  MESSAGE >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), msg))
         if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  count >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), count))
         scrollphat.write_string(msg)
         timeout = get_timeout()
         count = 0
      else :
         count = count + 2
   except KeyboardInterrupt :
      scrollphat.clear()
      sys.exit(-1)
###
