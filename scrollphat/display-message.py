#!/usr/bin/env python3
# 	display-message.py  3.189.331  2018-10-03_16:29:25_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.188  
# 	   Begin working  Change echo or print DEBUG INFO WARNING ERROR #45 
# 	display-message.py  3.188.330  2018-10-03_16:18:57_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.187  
# 	   example 1 only works for display-message and example 2 only works for display-message-hd close #42 
# 	display-message.py  3.160.302  2018-09-25_10:37:56_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.159  
# 	   scrollphat/display-message.py correct display_help close #39 
#
###	display-message.py - display contents of MESSAGE file
DEBUG = 1       # 0 = debug off, 1 = debug on
#
import subprocess
import sys
import time
import os
###
class color :
   BOLD = '\033[1m'
   END  = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help() :
   print ("\n{} - display contents of MESSAGE file".format( __file__))
   print ("\nUSAGE\n   {} [<MESSAGE_FILE>]".format(__file__))
   print ("   {} [--help | -help | help | -h | h | -?]".format(__file__))
   print ("   {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\nDisplay the contents of /usr/local/data/us-tx-cluster-1/MESSAGE (default)")
   print ("file on a Pimoroni Scroll-pHAT.  The Pimoroni Scroll-pHAT is attatched to a")
   print ("Raspberry Pi.  The default MESSAGE file name and absolute path can be")
   print ("overwritten by using environment variables (DATA_DIR, CLUSTER, MESSAGE_FILE).")
   print ("The environment variables can be overwritten by entering the MESSAGE file and")
   print ("absolute path as an argument to the display-message.py script.")
   print ("\nThe default MESSAGE file is created by create-message.sh script.  The")
   print ("create-message.sh script reads the /usr/local/data/us-tx-cluster-1/SYSTEMS file")
   print ("for the FQDN or IP address of the hosts in a cluster.  The default MESSAGE file")
   print ("contents includes the total number of containers, running containers, paused")
   print ("containers, stopped containers, and number of images in the cluster.")
   print ("\nEnvironment Variables")
   print ("If using the bash shell, enter; export CLUSTER='<cluster-name>' on the command")
   print ("line to set the CLUSTER environment variable.  Use the command, unset CLUSTER")
   print ("to remove the exported information from the CLUSTER environment variable.")
   print ("Setting an environment variable to be defined at login by adding it to")
   print ("~/.bashrc file or you can just modify the script with your default location")
   print ("for CLUSTER and DATA_DIR.  You are on your own defining environment variables")
   print ("if you are using other shells.")
   print ("   DATA_DIR      (default absolute path /usr/local/data/)")
   print ("   CLUSTER       (default us-tx-cluster-1/)")
   print ("   MESSAGE_FILE  (default MESSAGE)")
   print ("\nOPTIONS\n   MESSAGE_FILE - alternate message file,")
   print ("                  defualt /usr/local/data/us-tx-cluster-1/MESSAGE")
   print ("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/scrollphat")
   print ("\nEXAMPLES\n   Display contents using default file and path")
   print ("\n   {}".format(__file__))
   print ("\n   Display contents using a different cluster name and file name (bash)\n")
   print ("   export CLUSTER='us-west1/'")
   print ("   export MESSAGE_FILE='CONTAINER'")
   print ("   {}".format(__file__))
   print ("\n   Display contents from a different file and absolute path\n")
   print ("   {} /tmp/DIFFERENT_MESSAGE\n".format(__file__))
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

#  import scrollphat and check if scrollphat installed 
try :
   import scrollphat 
except ImportError :
   if sys.version_info[0] < 3 :
      sys.exit("\n{}{} {} {}[ERROR]{}  {}  Library scrollphat required. To install:\n\tsudo apt-get install python-scrollphat".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_date_stamp()))
   elif sys.version_info[0] == 3 :
      sys.exit("\n{}{} {} {}[ERROR]{}  {}  Library scrollphat required. To install:\n\tsudo apt-get install python3-scrollphat".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_date_stamp()))
except IOError :
      sys.exit("\n{}{} {} {}[ERROR]{}  {}  No such file or directory.  Is scrollphat installed on raspberry pi?".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_date_stamp()))

#  if argument; use argument -> do not use default or environment variables for MESSAGE
if no_arguments == 2 :
#  Set non-default MESSAGE file including path
   MESSAGE = sys.argv[1]
   if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), MESSAGE))
else :
#  if no argument; -> use default if environment variables not defined
   #  Check DATA_DIR; set using os environment variable
   if "DATA_DIR" in os.environ :
      DATA_DIR = os.getenv("DATA_DIR")
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable DATA_DIR >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), DATA_DIR))
   else :
   #  Set DATA_DIR with default
      DATA_DIR = "/usr/local/data/"
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable DATA_DIR NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), DATA_DIR))
   if "CLUSTER" in os.environ :
   #  Check CLUSTER; set using os environment variable
      CLUSTER = os.getenv("CLUSTER")
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable CLUSTER >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), CLUSTER))
   else :
   #  Set CLUSTER with default
      CLUSTER = "us-tx-cluster-1/"
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable CLUSTER NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), CLUSTER))
   if "MESSAGE_FILE" in os.environ :
   #  Check MESSAGE_FILE; set using os environment variable
      MESSAGE_FILE = os.getenv("MESSAGE_FILE")
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using environment variable MESSAGE_FILE >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), MESSAGE_FILE))
   else :
   #  Set MESSAGE_FILE with default
      MESSAGE_FILE = "MESSAGE"
      if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Environment variable MESSAGE_FILE NOT set, using default >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), MESSAGE_FILE))
   #  Set MESSAGE with absolute path
   MESSAGE = DATA_DIR + "/" + CLUSTER + "/" + MESSAGE_FILE
if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  Using MESSAGE file >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), MESSAGE))

#  Read TEMP_FILE contents and return contents
def get_msg(TEMP_FILE) :
   print ("\n{}{} {} {}[INFO]{}  {}  Reading MESSAGE file >{}<".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_date_stamp(), TEMP_FILE))
   file = open(TEMP_FILE,"r")
   CONTENT = file.read()
   file.close()
   CONTENT = CONTENT.rstrip('\n')
   return CONTENT

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
scrollphat.clear()
msg = get_msg(MESSAGE)
if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  MESSAGE >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), msg))
scrollphat.set_rotate(True)
scrollphat.write_string(msg)

while True :
   try :
      scrollphat.scroll()
      time.sleep(pause)
      if (count > timeout) :
         scrollphat.clear()
         msg = get_msg(MESSAGE)
         if DEBUG == 1 : print ("> {}DEBUG{} {}  {}  MESSAGE >{}<".format(color.BOLD, color.END, get_line_no(), get_date_stamp(), msg))
         scrollphat.write_string(msg)
         timeout = get_timeout()
         count = 0
      else :
         count = count + 1
   except KeyboardInterrupt :
      scrollphat.clear()
      sys.exit(-1)

print ("\n{}{} {} {}[INFO]{}  {}  Done.\n".format(color.END, __file__, get_line_no(), color.BOLD, color.END, get_date_stamp()))
###
