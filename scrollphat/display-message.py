#!/usr/bin/env python3
# 	scrollphat/display-message.py  3.262.406  2019-01-01T14:30:20.804401-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.261  
# 	   typo in comment 
# 	scrollphat/display-message.py  3.259.403  2018-12-30T19:58:17.644786-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.258  
# 	   display-message.py Change log format and order - lint pylint pylint3 close #65 
#
### display-message.py
#   production standard 3
import sys
import datetime
import time
import os
import subprocess
#       Order of precedence: environment variable (export DEBUG=1), default code
DEBUG = int(os.getenv("DEBUG", 0)) #  Set DEBUG,  0 = debug off, 1 = debug on, 'unset DEBUG' to unset environment variable (bash)
###
class color:
    BOLD = '\033[1m'
    END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
    print("\n{} - display contents of MESSAGE file".format(__file__))
    print("\nUSAGE\n   {} [<MESSAGE_FILE>]".format(__file__))
    print("   {} [--help | -help | help | -h | h | -?]".format(__file__))
    print("   {} [--version | -version | -v]".format(__file__))
    print("\nDESCRIPTION\nDisplay the contents of /usr/local/data/us-tx-cluster-1/MESSAGE (default)")
    print("file on a Pimoroni Scroll-pHAT.  The Pimoroni Scroll-pHAT is attatched to a")
    print("Raspberry Pi.  The default MESSAGE file name and absolute path can be")
    print("overwritten by using environment variables (DATA_DIR, CLUSTER, MESSAGE_FILE).")
    print("The environment variables can be overwritten by entering the MESSAGE file and")
    print("absolute path as an argument to the display-message.py script.")
    print("\nThe default MESSAGE file is created by create-message.sh script.  The")
    print("create-message.sh script reads the /usr/local/data/us-tx-cluster-1/SYSTEMS file")
    print("for the FQDN or IP address of the hosts in a cluster.  The default MESSAGE file")
    print("contents includes the total number of containers, running containers, paused")
    print("containers, stopped containers, and number of images in the cluster.")
    print("\nEnvironment Variables")
    print("If using the bash shell, enter; export CLUSTER='<cluster-name>' on the command")
    print("line to set the CLUSTER environment variable.  Use the command, unset CLUSTER")
    print("to remove the exported information from the CLUSTER environment variable.")
    print("Setting an environment variable to be defined at login by adding it to")
    print("~/.bashrc file or you can just modify the script with your default location")
    print("for CLUSTER and DATA_DIR.  You are on your own defining environment variables")
    print("if you are using other shells.")
    print("   DATA_DIR      (default absolute path /usr/local/data/)")
    print("   CLUSTER       (default us-tx-cluster-1/)")
    print("   MESSAGE_FILE  (default MESSAGE)")
    print("   DEBUG         (default '0')")
    print("\nOPTIONS\n   MESSAGE_FILE - alternate message file,")
    print("                  defualt /usr/local/data/us-tx-cluster-1/MESSAGE")
    print("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/scrollphat")
    print("\nEXAMPLES\n   Display contents using default file and path")
    print("\n   {}".format(__file__))
    print("\n   Display contents using a different cluster name and file name (bash)\n")
    print("   export CLUSTER='us-west1/'")
    print("   export MESSAGE_FILE='CONTAINER'")
    print("   {}".format(__file__))
    print("\n   Display contents from a different file and absolute path\n")
    print("   {} /tmp/DIFFERENT_MESSAGE\n".format(__file__))
#   After displaying help in english check for other languages
    if LANGUAGE != "en_US.UTF-8":
        print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  {} is not supported, Would you like to help translate?".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, LANGUAGE))
#   elif LANGUAGE == "fr_CA.UTF-8":
#       print display_help in french
#   else:
    return

#   Line number function
from inspect import currentframe
def get_line_no():
    cf = currentframe()
    return cf.f_back.f_lineno

#   Date and time function ISO 8601
def get_date_stamp():
    # calculate the offset taking into account daylight saving time
    utc_offset_sec = time.altzone if time.localtime().tm_isdst else time.timezone
    utc_offset = datetime.timedelta(seconds=-utc_offset_sec)
    ISO8601 = datetime.datetime.now().replace(tzinfo=datetime.timezone(offset=utc_offset)).isoformat()  + time.strftime(" (%Z)")
#   ISO8601 = time.strftime("%Y-%m-%dT%H:%M:%S%z") + time.strftime(" (%Z)") # previous solution
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

###
#   import scrollphat and check if scrollphat installed
try:
    import scrollphat
except ImportError:
    if sys.version_info[0] < 3:
        sys.exit("{}{} {} {}[{}] {} {} {} {}:{} {}[ERROR]{}  Library scrollphat required. To install:\tsudo apt-get install python-scrollphat".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
    elif sys.version_info[0] == 3:
        sys.exit("{}{} {} {}[{}] {} {} {} {}:{} {}[ERROR]{}  Library scrollphat required. To install:\tsudo apt-get install python-scrollphat".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
except IOError:
    sys.exit("{}{} {} {}[{}] {} {} {} {}:{} {}[ERROR]{}  No such file or directory.  Is scrollphat installed on raspberry pi?".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))

#   if argument; use argument -> do not use default or environment variables for MESSAGE
#   # NOTE: MESSAGE is absolute path and filename else use environment variables or default to build absolute path and filename
if no_arguments == 2:
#   Set non-default MESSAGE file including path
    MESSAGE = sys.argv[1]
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using MESSAGE file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGE))
else:
#   if no argument; -> use default if environment variables not defined
    #  Check DATA_DIR; set using os environment variable
    if "DATA_DIR" in os.environ:
        DATA_DIR = os.getenv("DATA_DIR")
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using environment variable DATA_DIR >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, DATA_DIR))
    else:
    #   Set DATA_DIR with default
        DATA_DIR = "/usr/local/data/"
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Environment variable DATA_DIR NOT set, using default >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, DATA_DIR))
    if "CLUSTER" in os.environ:
    #   Check CLUSTER; set using os environment variable
        CLUSTER = os.getenv("CLUSTER")
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using environment variable CLUSTER >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CLUSTER))
    else:
    #   Set CLUSTER with default
        CLUSTER = "us-tx-cluster-1/"
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Environment variable CLUSTER NOT set, using default >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CLUSTER))
    if "MESSAGE_FILE" in os.environ:
    #   Check MESSAGE_FILE; set using os environment variable
        MESSAGE_FILE = os.getenv("MESSAGE_FILE")
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using environment variable MESSAGE_FILE >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGE_FILE))
    else:
    #   Set MESSAGE_FILE with default
        MESSAGE_FILE = "MESSAGE"
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Environment variable MESSAGE_FILE NOT set, using default >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGE_FILE))
    #   Set MESSAGE with absolute path
    MESSAGE = DATA_DIR + "/" + CLUSTER + "/" + MESSAGE_FILE
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using MESSAGE file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGE))
###

#   Read TEMP_FILE contents and return contents
def get_msg(TEMP_FILE):
    print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  Reading MESSAGE file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, TEMP_FILE))
    file = open(TEMP_FILE, "r")
    CONTENT = file.read()
    file.close()
    CONTENT = CONTENT.rstrip('\n')
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  CONTENT >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CONTENT))
    return CONTENT

#   timeout
def get_timeout():
    return ticks_per_second * refresh_interval

#   Set brightness
scrollphat.set_brightness(4)
#   Every refresh_interval seconds we'll refresh
#   Only has to change every 60 seconds.
pause = 0.12
ticks_per_second = 1/pause
refresh_interval = 60
timeout = get_timeout()
count = 0
scrollphat.clear_buffer()
msg = get_msg(MESSAGE)
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  MESSAGE >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, msg))
scrollphat.set_rotate(True)
scrollphat.write_string(msg)

#
while True:
    try:
        scrollphat.scroll()
        time.sleep(pause)
        if (count > timeout):
            scrollphat.clear_buffer()
            msg = get_msg(MESSAGE)
            if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  MESSAGE >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, msg))
            scrollphat.write_string(msg)
            timeout = get_timeout()
            count = 0
        else:
            count = count + 1
    except KeyboardInterrupt:
        scrollphat.clear_buffer()
        sys.exit(-1)

#   Done
print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  Operation finished.".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
###
