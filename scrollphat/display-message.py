#!/usr/bin/env python3
# 	display-message.py  3.125.267  2018-09-19_23:34:41_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.124  
# 	   completed display-help 
# 	display-message.py  3.124.266  2018-09-19_16:49:47_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.123  
# 	   typo 
# 	display-message.py  3.123.265  2018-09-19_16:41:22_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.122  
# 	   add support for environment variables to override default 
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
   print ("\nDESCRIPTION\nDisplay the contents of /usr/local/data/us-tx-cluster-1/MESSAGE (default)")
   print ("file on a Pimoroni Scroll-pHAT.  The Pimoroni Scroll-pHAT is attatched to a")
   print ("Raspberry Pi.  The default MESSAGE file name and absolute path can be")
   print ("overwritten by using environment variables (DATA_DIR, CLUSTER, MESSAGE_FILE).")
   print ("The environment variables can be overwritten by entering the MESSAGE file and")
   print ("absolute path as an argument to the display-message.py script.")
   print ("\nThe MESSAGE file contents includes the total number of containers, running")
   print ("containers, paused containers, stopped containers, and number of images in the")
   print ("cluster.")

   print ("\nThe MESSAGE file is created by create-message.sh script.  The")
   print ("create-message.sh script reads the /usr/local/data/us-tx-cluster-1/SYSTEMS file")
   print ("for the FQDN or IP address of the hosts in a cluster.")
   print ("\nEnvironment Variables\n   DATA_DIR      (default /usr/local/data/)")
   print ("   CLUSTER       (default us-tx-cluster-1/)")
   print ("   MESSAGE_FILE  (default MESSAGE)")
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

#  if argument; use argument -> do not use default or environment variables for MESSAGE
if no_arguments == 2 :
#  Set non-default MESSAGE file including path
   MESSAGE = sys.argv[1]
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE))
else :
#  if no argument; -> use default and/or environment variables for MESSAGE
   #  Check DATA_DIR; set using os environment variable
   if "DATA_DIR" in os.environ :
      DATA_DIR = os.getenv("DATA_DIR")
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable DATA_DIR >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), DATA_DIR))
   else :
   #  Set DATA_DIR with default
      DATA_DIR = "/usr/local/data/"
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable DATA_DIR NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), DATA_DIR))
   if "CLUSTER" in os.environ :
   #  Check CLUSTER; set using os environment variable
      CLUSTER = os.getenv("CLUSTER")
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable CLUSTER >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), CLUSTER))
   else :
   #  Set CLUSTER with default
      CLUSTER = "us-tx-cluster-1/"
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable CLUSTER NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), CLUSTER))
   if "MESSAGE_FILE" in os.environ :
   #  Check MESSAGE_FILE; set using os environment variable
      MESSAGE_FILE = os.getenv("MESSAGE_FILE")
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable MESSAGE_FILE >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))
   else :
   #  Set MESSAGE_FILE with default
      MESSAGE_FILE = "MESSAGE"
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable MESSAGE_FILE NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE_FILE))
   #  Set default MESSAGE file with path
   MESSAGE = DATA_DIR + CLUSTER + MESSAGE_FILE
if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), MESSAGE))

#  Read TEMP_FILE contents and return contents
def get_msg(TEMP_FILE) :
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Reading MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_time_stamp(), TEMP_FILE))
   file = open(TEMP_FILE,"r")
   FILE_CONTENT = file.read()
   file.close()
   FILE_CONTENT = FILE_CONTENT + " ---> "
   return FILE_CONTENT
###

#  timeout
def get_timeout() :
   return ticks_per_second * refresh_interval

#  Set brightness
scrollphat.set_brightness(4)
# Every refresh_interval seconds we'll refresh
# Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60

timeout = get_timeout()
count = 0
msg = get_msg(MESSAGE)
scrollphat.set_rotate(True)
scrollphat.write_string(msg)

while True :
   try :
      scrollphat.scroll()
      time.sleep(pause)

      if (count > timeout) :
         msg = get_msg(MESSAGE)
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
