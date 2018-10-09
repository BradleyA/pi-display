#!/usr/bin/env python3
# 	../blinkt/display-led.py  3.199.341  2018-10-08T23:51:49-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.198  
# 	   minor changes 
# 	../blinkt/display-led.py  3.198.340  2018-10-08T22:47:13-05:00 (CDT)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.197  
# 	   test blinkt/display-led.py with crontab 
# 	display-led.py  3.187.329  2018-10-03_15:05:05_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.186  
# 	   Change echo or print DEBUG INFO WARNING ERROR  close #44 
#
###	display-led.py - display system status on blinkt
#
#	The final design should control an Blinkt LED bar on Raspberry pi and
#		display information for a second
#	Each color level function will exit with the primary color on
#	Color brightness controlled in each color level function
###
DEBUG = 0       # 0 = debug off, 1 = debug on
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
   LANGUAGE = os.getenv("LANG")
   print ("\n{} - display system status on blinkt".format( __file__))
   print ("\nUSAGE\n   {} [<CLUSTER>] [<DATA_DIR>]".format(__file__))
   print ("   {} [--help | -help | help | -h | h | -?]".format(__file__))
   print ("   {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\nThis script displays the system information stored in a file,")
   print ("/usr/local/data/us-tx-cluster-1/<hostname>, on each system.  The system")
   print ("information is displayed using a Raspberry Pi with Pimoroni Blinkt.  The system")
   print ("information includes cpu temperature in Celsius and Fahrenheit, the system")
   print ("load, memory usage, and disk usage.")
   print ("\nEnvironment Variables")
   print ("If using the bash shell, enter; export CLUSTER='<cluster-name>' on the command")
   print ("line to set the CLUSTER environment variable.  Use the command, unset CLUSTER")
   print ("to remove the exported information from the CLUSTER environment variable.")
   print ("Setting an environment variable to be defined at login by adding it to")
   print ("~/.bashrc file or you can just modify the script with your default location")
   print ("for CLUSTER and DATA_DIR.  You are on your own defining environment variables")
   print ("if you are using other shells.")
   print ("   CLUSTER       (default us-tx-cluster-1/)")
   print ("   DATA_DIR      (default absolute path /usr/local/data/)")
   print ("\nOPTIONS")
   print ("   CLUSTER       name of cluster directory, default us-tx-cluster-1/")
   print ("   DATA_DIR      absolute path to cluster data directory, default /usr/local/data/")
   print ("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/blinkt")
   print ("\nEXAMPLES\n   Display contents using default file and path\n")
   print ("   {} \n".format(__file__))
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

#  Date and time function ISO 8601
def get_date_stamp() :
   ISO8601 = time.strftime("%Y-%m-%dT%H:%M:%S%z") + time.strftime(" (%Z)")
   return ISO8601

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
UID = os.getuid()
GID = os.getgid()
if DEBUG == 1 : print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {} {}  Set user variables".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID))

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

#  if argument; use argument -> do not use environment variables or default for CLUSTER
if no_arguments >= 2 :
   CLUSTER = sys.argv[1]
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Using 1 argument CLUSTER >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, CLUSTER))
elif "CLUSTER" in os.environ :
   #  Check CLUSTER; set using os environment variable
   CLUSTER = os.getenv("CLUSTER")
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Using environment variable CLUSTER >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, CLUSTER))
else :
   #  Set CLUSTER with default
   CLUSTER = "us-tx-cluster-1/"
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Environment variable CLUSTER NOT set, using default >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, CLUSTER))

#  if argument; use argument -> do not use environment variables or default for DATA_DIR
if no_arguments == 3 :
   DATA_DIR = sys.argv[2]
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Using 2 argument DATA_DIR >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, DATA_DIR))
elif "DATA_DIR" in os.environ :
   #  Check DATA_DIR; set using os environment variable
   DATA_DIR = os.getenv("DATA_DIR")
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Using environment variable DATA_DIR >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, DATA_DIR))
else :
   #  Set DATA_DIR with default
   DATA_DIR = "/usr/local/data/"
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Environment variable DATA_DIR NOT set, using default >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, DATA_DIR))

#  Example set fully qualified domain name
from socket import getfqdn
#
LOCALHOST = getfqdn()

#
FILE_NAME = DATA_DIR + "/" + CLUSTER + "/" + LOCALHOST
if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  FILE_NAME >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, FILE_NAME))

###
from blinkt import set_clear_on_exit, set_pixel, show, clear
#
set_clear_on_exit(True)
clear()
show()
time.sleep(2) # 1 = 1 second

#   Normal services and operations
#	GREEN : no known incidents
#   LED_number argument 0-7
def status1(LED_number) :
   set_pixel(LED_number, 0, 255, 0, 0.2)
   show()
   return();

#   Incidents causing no disruption to overall services and operations
#	LIGHT GREEN : an incident (watch)
#   LED_number argument 0-7
def status2(LED_number) :
   for i in range(0, 5) :
      set_pixel(LED_number, 0, 0, 0, 0)
      show()
      time.sleep(0.05) # 1 = 1 second
      set_pixel(LED_number, 50, 205, 50, 0.1)
      show()
      time.sleep(0.15) # 1 = 1 second
   return();

#  Active incident with minimal affect to overall services and operations
#	YELLOW : additional incidents WARNING (alert)
#   LED_number argument 0-7
def status3(LED_number) :
   for i in range(0, 5) :
      set_pixel(LED_number, 0, 255, 0, 0.8)
      show()
      time.sleep(0.05) # 1 = 1 second
      set_pixel(LED_number, 0, 0, 0, 0)
      show()
      time.sleep(0.03) # 1 = 1 second
      set_pixel(LED_number, 255, 255, 0, 0.2)
      show()
      time.sleep(0.15) # 1 = 1 second
   return();

#  Active emergency incidents causing significant impact to operations and possiable service disruptions
#	ORANGE : CRITICAL ERROR
#   LED_number argument 0-7
def status4(LED_number) :
   for i in range(0,10) :
      set_pixel(LED_number, 255, 255, 0, 0.8)
      show()
      time.sleep(0.05) # 1 = 1 second
      set_pixel(LED_number, 0, 0, 0, 0)
      show()
      time.sleep(0.03) # 1 = 1 second
      set_pixel(LED_number, 255, 35, 0, 0.1)
      show()
      time.sleep(0.05) # 1 = 1 second
   return();

#   Active emergency incidents causing multiple impaired operations amd unavoidable severe service disruptions
#	RED : Emergency Conditions : FATAL ERROR : 
#   LED_number argument 0-7
def status5(LED_number) :
   for i in range(0,10) :
      set_pixel(LED_number, 255, 35, 0, 0.8)
      show()
      time.sleep(0.05) # 1 = 1 second
      set_pixel(LED_number, 0, 0, 0, 0)
      show()
      time.sleep(0.03) # 1 = 1 second
      set_pixel(LED_number, 255, 0, 0, 0.2)
      show()
      time.sleep(0.05) # 1 = 1 second
   return();

#
#       VIOLET : the statistic is  WARNING (alert)
#   LED_number argument 0-7
def status6(LED_number) :
   set_pixel(LED_number, 127, 0, 255, 0.1)
   show()
   time.sleep(2) # 1 = 1 second
   return();

#   process information
def process(line) :
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Begin to process >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, line.lower().rstrip('\n')))
   if 'celsius:' in line.lower() :
      VALUE = float(line[line.find(':')+2:])
      LED_number = 7
      if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  celsius: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, VALUE, LED_number))
      if   VALUE < 48.5 : # < 48.5 C 119.3  1
         status1(LED_number)
      elif VALUE < 59   : # < 59 C   138.2  2
         status2(LED_number)
      elif VALUE < 69.5 : # < 69.5 C 157.1  3
         status3(LED_number)
      elif VALUE < 80   : # < 80 C   176    4
         status4(LED_number)
      elif VALUE >= 80  :   # > 80 C 176    5
         status5(LED_number) 
   if 'cpu_usage:' in line.lower() :
      VALUE = int(line[line.find(':')+2:])
      LED_number = 6
      if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  cpu_usage: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, VALUE, LED_number))
      if   VALUE < 70 : # < 70 %
         status1(LED_number)
      elif VALUE < 80 : # < 80 %
         status2(LED_number)
      elif VALUE < 85 : # < 85 %
         status3(LED_number)
      elif VALUE < 90 : # < 90 %
         status4(LED_number)
      elif VALUE >= 90 : # >= 95 %
         status5(LED_number) 
   if 'memory_usage:' in line.lower() :
      VALUE = int(line.split(' ')[2])
      LED_number = 5
      if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  memory_usage: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, VALUE, LED_number))
      if   VALUE < 70 : # < 70 %
         status1(LED_number)
      elif VALUE < 80 : # < 80 %
         status2(LED_number)
      elif VALUE < 85 : # < 85 %
         status3(LED_number)
      elif VALUE < 90 : # < 90 %
         status4(LED_number)
      elif VALUE >= 90 : # >= 95 %
         status5(LED_number) 
   if 'disk_usage:' in line.lower() :
      VALUE = int(line.split(' ')[2])
      LED_number = 4
      if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  disk_usage: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, VALUE, LED_number))
      if   VALUE < 70 : # < 70 %
         status1(LED_number)
      elif VALUE < 80 : # < 80 %
         status2(LED_number)
      elif VALUE < 85 : # < 85 %
         status3(LED_number)
      elif VALUE < 90 : # < 90 %
         status4(LED_number)
      elif VALUE >= 90 : # >= 95 %
         status5(LED_number) 
   return();

###
#   read file and process information
with open(FILE_NAME) as f :
   print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  FILE_NAME >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, FILE_NAME))
   for line in f :
      process(line)

time.sleep(6) # 1 = 1 second

#
print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Done.".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID))
###
