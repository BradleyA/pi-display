#!/usr/bin/env python3
# 	blinkt/display-led.py  3.318.504  2019-01-12T15:24:43.562357-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.317  
# 	   template.[sh,py] production standard 4 change display_help of other LANG 
# 	blinkt/display-led.py  3.260.404  2018-12-30T20:06:23.081708-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.259  
# 	   blinkt/display-led.py Change echo or print DEBUG INFO WARNING ERROR close #57 
#
### display-led.py
#	The final design should control an Blinkt LED bar on Raspberry pi and
#		display information for a second
#	Each color level function will exit with the primary color on
#	Color brightness controlled in each color level function
###
#   production standard 4
import sys
import datetime
import time
import os
#       Order of precedence: environment variable (export DEBUG=1), default code
DEBUG = int(os.getenv("DEBUG", 0)) #  Set DEBUG,  0 = debug off, 1 = debug on, 'unset DEBUG' to unset environment variable (bash)
###
class color:
    BOLD = '\033[1m'
    END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
    LANGUAGE = os.getenv("LANG")
    print("\n{} - display system status on blinkt".format(__file__))
    print("\nUSAGE\n   {} [<CLUSTER>] [<DATA_DIR>]".format(__file__))
    print("   {} [--help | -help | help | -h | h | -?]".format(__file__))
    print("   {} [--version | -version | -v]".format(__file__))
    print("\nDESCRIPTION")
#   Displaying help DESCRIPTION in English en_US.UTF-8
    print("This script displays the system information stored in a file,")
    print("/usr/local/data/us-tx-cluster-1/<hostname>, on each system.  The system")
    print("information is displayed using a Raspberry Pi with Pimoroni Blinkt.  The system")
    print("information includes cpu temperature in Celsius and Fahrenheit, the system")
    print("load, memory usage, and disk usage.")
#       Displaying help DESCRIPTION in French
    if (LANGUAGE == "fr_CA.UTF-8") or (LANGUAGE == "fr_FR.UTF-8") or (LANGUAGE == "fr_CH.UTF-8"):
        print("\n--> {}".format(LANGUAGE))
        print("<votre aide va ici>")
        print("Souhaitez-vous traduire la section description?")
    elif (LANGUAGE != "en_US.UTF-8"):
        print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  {} is not supported, Would you like to help translate the description section?".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, LANGUAGE))
    print("\nEnvironment Variables")
    print("If using the bash shell, enter; export CLUSTER='<cluster-name>' on the command")
    print("line to set the CLUSTER environment variable.  Use the command, unset CLUSTER")
    print("to remove the exported information from the CLUSTER environment variable.")
    print("Setting an environment variable to be defined at login by adding it to")
    print("~/.bashrc file or you can just modify the script with your default location")
    print("for CLUSTER and DATA_DIR.  You are on your own defining environment variables")
    print("if you are using other shells.")
    print("   CLUSTER       (default us-tx-cluster-1/)")
    print("   DATA_DIR      (default absolute path /usr/local/data/)")
    print("\nOPTIONS")
    print("   CLUSTER       name of cluster directory, default us-tx-cluster-1/")
    print("   DATA_DIR      absolute path to cluster data directory, default /usr/local/data/")
    print("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/blinkt")
    print("\nEXAMPLES\n   Display contents using default file and path\n")
    print("   {} \n".format(__file__))
    return

#   Line number function
from inspect import currentframe
def get_line_no():
    cf = currentframe()
    return cf.f_back.f_lineno

#   Date and time function ISO 8601
def get_date_stamp():
    #   calculate the offset taking into account daylight saving time
    utc_offset_sec = time.altzone if time.localtime().tm_isdst else time.timezone
    utc_offset = datetime.timedelta(seconds=-utc_offset_sec)
    ISO8601 = datetime.datetime.now().replace(tzinfo=datetime.timezone(offset=utc_offset)).isoformat()  + time.strftime(" (%Z)")
#      ISO8601 = time.strftime("%Y-%m-%dT%H:%M:%S%z") + time.strftime(" (%Z)") # previous solution
    return ISO8601

#   Fully qualified domain name
from socket import getfqdn
#   FQDN hostname
LOCALHOST = getfqdn()

#   Version
with open(__file__) as f:
    f.readline()
    line2 = f.readline()
    line2 = line2.split()
    SCRIPT_NAME = line2[1]
    SCRIPT_VERSION = line2[2]
    f.close()

#   Set user variables
if "LOGNAME" in os.environ: LOGNAME = os.getenv("LOGNAME") # Added three lines because USER is not defined in crobtab jobs
if "USER" in os.environ: USER = os.getenv("USER")
else: USER = LOGNAME
#
UID = os.getuid()
GID = os.getgid()
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Setting USER to support crobtab...".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))

#   Default help and version arguments
no_arguments = int(len(sys.argv))
if no_arguments == 2:
#   Default help output
    if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?':
        display_help()
        sys.exit()
#   Default version output
    if sys.argv[1] == '--version' or sys.argv[1] == '-version' or sys.argv[1] == 'version' or sys.argv[1] == '-v':
        print("{} {}".format(SCRIPT_NAME, SCRIPT_VERSION))
        sys.exit()

#   Begin script INFO
print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  Started...".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))

#   DEBUG example
from platform import python_version
#
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Version of python >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, python_version()))

#   if argument; use argument -> do not use environment variables or default for CLUSTER
if no_arguments >= 2:
    CLUSTER = sys.argv[1]
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using 1 argument CLUSTER >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CLUSTER))
elif "CLUSTER" in os.environ:
    #   Check CLUSTER; set using os environment variable
    CLUSTER = os.getenv("CLUSTER")
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using environment variable CLUSTER >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CLUSTER))
else:
    #   Set CLUSTER with default
    CLUSTER = "us-tx-cluster-1/"
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Environment variable CLUSTER NOT set, using default >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CLUSTER))

#   if argument; use argument -> do not use environment variables or default for DATA_DIR
if no_arguments == 3:
    DATA_DIR = sys.argv[2]
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using 2 argument DATA_DIR >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, DATA_DIR))
elif "DATA_DIR" in os.environ:
    #   Check DATA_DIR; set using os environment variable
    DATA_DIR = os.getenv("DATA_DIR")
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using environment variable DATA_DIR >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, DATA_DIR))
else:
    #   Set DATA_DIR with default
    DATA_DIR = "/usr/local/data/"
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Environment variable DATA_DIR NOT set, using default >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, DATA_DIR))

#
FILE_NAME = DATA_DIR + "/" + CLUSTER + "/" + LOCALHOST
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  FILE_NAME >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, FILE_NAME))

###
from blinkt import set_clear_on_exit, set_pixel, show, clear
#
set_clear_on_exit(True)
clear()
show()

#   Normal services and operations
#	GREEN : no known incidents
#   LED_number argument 0-7
def status1(LED_number):
    global DISPLAY_TIME
    set_pixel(LED_number, 0, 255, 0, 0.2)
    show()
    DISPLAY_TIME = DISPLAY_TIME - 0.01
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  DISPLAY_TIME >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, DISPLAY_TIME))
    return()

#   Incidents causing no disruption to overall services and operations
#	LIGHT GREEN : an incident (watch)
#   LED_number argument 0-7
def status2(LED_number):
    global DISPLAY_TIME
    for i in range(0, 5):
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 50, 205, 50, 0.1)
        show()
        time.sleep(0.15) # 1 = 1 second
        DISPLAY_TIME = DISPLAY_TIME - 0.20
    return()

#   Active incident with minimal affect to overall services and operations
#	YELLOW : additional incidents WARNING (alert)
#   LED_number argument 0-7
def status3(LED_number):
    global DISPLAY_TIME
    for i in range(0, 5):
        set_pixel(LED_number, 0, 255, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 255, 0, 0.2)
        show()
        time.sleep(0.15) # 1 = 1 second
        DISPLAY_TIME = DISPLAY_TIME - 0.23
    return()

#   Active emergency incidents causing significant impact to operations and possiable service disruptions
#	ORANGE : CRITICAL ERROR
#   LED_number argument 0-7
def status4(LED_number):
    global DISPLAY_TIME
    for i in range(0, 10):
        set_pixel(LED_number, 255, 255, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 35, 0, 0.1)
        show()
        time.sleep(0.05) # 1 = 1 second
        DISPLAY_TIME = DISPLAY_TIME - 0.13
    return()

#   Active emergency incidents causing multiple impaired operations amd unavoidable severe service disruptions
#	RED : Emergency Conditions : FATAL ERROR :
#   LED_number argument 0-7
def status5(LED_number):
    global DISPLAY_TIME
    for i in range(0, 10):
        set_pixel(LED_number, 255, 35, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 0, 0, 0.2)
        show()
        time.sleep(0.05) # 1 = 1 second
        DISPLAY_TIME = DISPLAY_TIME - 0.13
    return()

#
#       VIOLET : the statistic is  WARNING (alert)
#   LED_number argument 0-7
def status6(LED_number):
    global DISPLAY_TIME
    set_pixel(LED_number, 127, 0, 255, 0.1)
    show()
    time.sleep(2) # 1 = 1 second
    DISPLAY_TIME = DISPLAY_TIME - 2
    return()

#   process information
def process(line):
    global DISPLAY_TIME
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Begin to process >{}<   DISPLAY_TIME >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, line.lower().rstrip('\n'), DISPLAY_TIME))
#   celsius
    if 'celsius:' in line.lower():
        VALUE = float(line[line.find(':')+2:])
        LED_number = 7
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  celsius: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, VALUE, LED_number))
        if   VALUE < 48.5:  # < 48.5 C 119.3  1
            status1(LED_number)
        elif VALUE < 59:    # < 59 C   138.2  2
            status2(LED_number)
        elif VALUE < 69.5:  # < 69.5 C 157.1  3
            status3(LED_number)
        elif VALUE < 80:    # < 80 C   176    4
            status4(LED_number)
        elif VALUE >= 80:   # > 80 C 176    5
            status5(LED_number)
#   cpu_usage
    if 'cpu_usage:' in line.lower():
        VALUE = int(line[line.find(':')+2:])
        LED_number = 6
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  cpu_usage: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, VALUE, LED_number))
        if   VALUE < 70:    # < 70 %    tested with 10
            status1(LED_number)
        elif VALUE < 80:    # < 80 %    tested with 20
            status2(LED_number)
        elif VALUE < 85:    # < 85 %    tested with 35
            status3(LED_number)
        elif VALUE < 90:    # < 90 %    tested with 50
            status4(LED_number)
        elif VALUE >= 90:   # >= 95 %    tested with 50
            status5(LED_number)
#   memory_usage
    if 'memory_usage:' in line.lower():
        VALUE = int(line.split(' ')[2])
        LED_number = 5
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  memory_usage: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, VALUE, LED_number))
        if   VALUE < 70:    # < 70 %
            status1(LED_number)
        elif VALUE < 80:    # < 80 %
            status2(LED_number)
        elif VALUE < 85:    # < 85 %
            status3(LED_number)
        elif VALUE < 90:    # < 90 %
            status4(LED_number)
        elif VALUE >= 90:   # >= 95 %
            status5(LED_number)
#   disk_usage
    if 'disk_usage:' in line.lower():
        VALUE = int(line.split(' ')[2])
        LED_number = 4
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  disk_usage: VALUE >{}< LED_number >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, VALUE, LED_number))
        if   VALUE < 60:    # < 60 %
            status1(LED_number)
        elif VALUE < 75:    # < 75 %
            status2(LED_number)
        elif VALUE < 80:    # < 80 %
            status3(LED_number)
        elif VALUE < 90:    # < 90 %
            status4(LED_number)
        elif VALUE >= 90:   # >= 90 %
            status5(LED_number)
    return()

###
#   display-led.py called by cron every 15 seconds
DISPLAY_TIME = 15.00 - 8

#   read file and process information
with open(FILE_NAME) as f:
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  FILE_NAME >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, FILE_NAME))
    for line in f:
        process(line)
f.close()

#   Leave LEDs on while time.sleep
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  DISPLAY_TIME >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, int(DISPLAY_TIME)))
time.sleep(int(DISPLAY_TIME)) # 1 = 1 second

#   Done
print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  Operation finished.".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
###
