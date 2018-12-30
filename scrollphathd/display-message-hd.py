#!/usr/bin/env python3
# 	scrollphathd/display-message-hd.py  3.251.394  2018-12-29T23:56:46.245914-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.250  
# 	   Change log format and order close #63 
# 	display-message-hd.py  3.195.337  2018-10-03_20:56:53_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.194  
# 	   Change echo or print DEBUG INFO WARNING ERROR close #46 
# 	display-message-hd.py  3.194.336  2018-10-03_20:17:36_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.193  
# 	   add support for environment variables close #40 
# 	display-message-hd.py  3.173.315  2018-09-29_18:51:05_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.172  
# 	   no more incidnet with #25 close #25 
### display-message-hd.py
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
    print("\n{} - display contents of MESSAGEHD file".format(__file__))
    print("\nUSAGE\n  {} [<MESSAGEHD_FILE>]".format(__file__))
    print("  {} [--help | -help | help | -h | h | -?]".format(__file__))
    print("  {} [--version | -version | -v]".format(__file__))
    print("\nDESCRIPTION\nDisplay the contents of /usr/local/data/<cluster-name>/MESSAGEHD  (default)")
    print("file on a Pimoroni Scroll-pHAT-HD.  The Pimoroni Scroll-pHAT-HD is attatched")
    print("to a Raspberry Pi.  The default MESSAGEHD file name and absolute path can be")
    print("overwritten by using environment variables (DATA_DIR, CLUSTER, MESSAGEHD).")
    print("The environment variables can be overwritten by entering the MESSAGEHD file")
    print("and absolute path as an argument to the display-message-hd.py script.")
    print("\nThe default MESSAGEHD file is created by create-message.sh script.  The")
    print("create-message.sh script reads the /usr/local/data/us-tx-cluster-1/SYSTEMS file")
    print("for the FQDN or IP address of the hosts in a cluster.  The default MESSAGEHD")
    print("file contents includes the total number of containers, running containers,")
    print("paused containers, stopped containers, and number of images in the cluster.")
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
    print("   MESSAGEHD     (default MESSAGEHD)")
    print("   DEBUG         (default '0')")
    print("\nOPTIONS\n   MESSAGEHD_FILE - alternate MESSAGEHD file and absolute path,")
    print("                  defualt /usr/local/data/us-tx-cluster-1/MESSAGEHD")
    print("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/scrollphathd\n")
    print("\nEXAMPLES\n   Display contents using default file and path")
    print("\n   {}".format(__file__))
    print("\n   Display contents using a different cluster name and file name (bash)\n")
    print("   export CLUSTER='us-west1/'")
    print("   export MESSAGEHD='CONTAINER'")
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
#   if argument; use argument -> do not use default or environment variables for MESSAGEHD
#   # NOTE: MESSAGEHD is absolute path and filename else use environment variables or default to build absolute path and filename
if no_arguments == 2:
#   Set non-default MESSAGEHD file including path
    MESSAGEHD = sys.argv[1]
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using MESSAGEHD file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGEHD))
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
        if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Using environment variable CLUSTER >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, USER, UID, GID, CLUSTER))
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using environment variable CLUSTER >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CLUSTER))
    else:
    #   Set CLUSTER with default
        CLUSTER = "us-tx-cluster-1/"
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Environment variable CLUSTER NOT set, using default >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CLUSTER))
    if "MESSAGEHD" in os.environ:
    #   Check MESSAGEHD; set using os environment variable
        MESSAGEHD = os.getenv("MESSAGEHD")
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using environment variable MESSAGEHD >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGEHD))
    else:
    #   Set MESSAGEHD with default
        MESSAGEHD = "MESSAGEHD"
        if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Environment variable MESSAGEHD NOT set, using default >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGEHD))
    #   Set MESSAGEHD with absolute path
    MESSAGEHD_FILE = DATA_DIR + "/" + CLUSTER + "/" + MESSAGEHD
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using MESSAGEHD file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGEHD))
###

#   Check argument 1 for non-default MESSAGEHD file
if no_arguments == 2:
    MESSAGEHD_FILE = sys.argv[1]
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using MESSAGEHD_FILE file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGEHD_FILE))
else:
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Using MESSAGEHD_FILE file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, MESSAGEHD_FILE))

#  Read TEMP_FILE contents and return contents #41
def get_msg(TEMP_FILE):
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Reading MESSAGE file >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, TEMP_FILE))
    file = open(TEMP_FILE,"r")
    CONTENT = file.read().splitlines()
    file.close()
#	   CONTENT = CONTENT = "['   ']"
    if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  CONTENT >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, CONTENT))
    return CONTENT

### 
import signal
import scrollphathd
from scrollphathd.fonts import font3x5

scrollphathd.set_clear_on_exit()
#   Rotate the text
scrollphathd.rotate(180)
#   Set brightness
scrollphathd.set_brightness(0.2)
#   If rewind is True the scroll effect will rapidly rewind after the last line
# >>> oeg	rewind = True
rewind = False
#   Delay is the time (in seconds) between each pixel scrolled
delay = 0.03
#   Determine how far apart each line should be spaced vertically
line_height = scrollphathd.DISPLAY_HEIGHT + 2
#

###
#   Store the left offset for each subsequent line (starts at the end of the last line)
offset_left = 0
#   Get message from MESSAGEHD file created by create-message.sh
lines = get_msg(MESSAGEHD_FILE)
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Show lines >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, lines))
#   Code from Pimoroni scrollphathd/examples/advanced-scrolling.py
#   Draw each line in lines to the Scroll pHAT HD buffer
#   scrollphathd.write_string returns the length of the written string in pixels
#   we can use this length to calculate the offset of the next line
#   and will also use it later for the scrolling effect.
lengths = [0] * len(lines)
#  
scrollphathd.fill(0,0,0)  #25  This is what fixed incident #25
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  Before 'for' loop;  lengths >{}<  offset_left >{}<  line_height >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, lengths, offset_left, line_height)) #25
for line, text in enumerate(lines):
    lengths[line] = scrollphathd.write_string(text, x=offset_left, y=line_height * line)
    offset_left += lengths[line]
if DEBUG == 1: print("{}{} {} {}[{}] {} {} {} {}:{} {}[DEBUG]{}  After 'for' loop;  lengths >{}<  offset_left >{}<  line_height >{}<".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END, lengths, offset_left, line_height)) #25
#   This adds a little bit of horizontal/vertical padding into the buffer at
#   the very bottom right of the last line to keep things wrapping nicely.
scrollphathd.set_pixel(offset_left - 1, (len(lines) * line_height) - 1, 0)
#   Reset the animation
scrollphathd.scroll_to(0, 0)
scrollphathd.show()
#   Keep track of the X and Y position for the rewind effect
pos_x = 0
pos_y = 0
for current_line, line_length in enumerate(lengths):
    #  Delay a slightly longer time at the start of each line
    #
    # >>> org      time.sleep(delay*10)
    time.sleep(delay*30)
    #   Scroll to the end of the current line
    for y in range(line_length):
        scrollphathd.scroll(1, 0)
        pos_x += 1
        time.sleep(delay)
        scrollphathd.show()
    #   If we're currently on the very last line and rewind is True
    #   We should rapidly scroll back to the first line.
    if current_line == len(lines) - 1 and rewind:
        for y in range(pos_y):
            scrollphathd.scroll(-int(pos_x/pos_y), -1)
            scrollphathd.show()
            time.sleep(delay)
    #   Otherwise, progress to the next line by scrolling upwards
    else:
        for x in range(line_height):
            scrollphathd.scroll(0, 1)
            pos_y += 1
            scrollphathd.show()
            time.sleep(delay)

#   Done
print("{}{} {} {}[{}] {} {} {} {}:{} {}[INFO]{}  Operation finished.".format(color.END, get_date_stamp(), LOCALHOST, __file__, os.getpid(), SCRIPT_VERSION, get_line_no(), USER, UID, GID, color.BOLD, color.END))
###
