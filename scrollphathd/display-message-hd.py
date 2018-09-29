#!/usr/bin/env python3
# 	display-message-hd.py  3.172.314  2018-09-29_18:46:10_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.171  
# 	   update print for INFO DEBUG 
# 	display-message-hd.py  3.171.313  2018-09-29_17:49:30_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.170  
# 	   update Begin script INFO #25 
###
DEBUG = 1       # 0 = debug off, 1 = debug on
#
import subprocess
import sys
import time
import os
###
class color:
   BOLD = '\033[1m'
   END  = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
   print ("\n{} - display contents of MESSAGEHD file".format(__file__))
   print ("\nUSAGE\n  {} [<MESSAGEHD_file>]".format(__file__))
   print ("  {} [--help | -help | help | -h | h | -?]".format(__file__))
   print ("  {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\nDisplay the contents of /usr/local/data/<cluster-name>/MESSAGEHD file on a")
   print ("Scroll-pHAT-HD.  The MESSAGEHD file includes the total number of containers,")
   print ("running containers, paused containers, stopped containers, and number of")
   print ("images in the cluster.  The MESSAGEHD file is used by a Raspberry Pi Scroll-pHAT")
   print ("or Scroll-pHAT-HD to display the current information.  The MESSAGEHD file is")
   print ("created by create-message.sh script.  The create-message.sh script reads the")
   print ("/usr/local/data/<cluster-name>/SYSTEMS file for the FQDN or IP address of the")
   print ("hosts in a cluster.")
   print ("\nOPTIONS\n   MESSAGEHD_file - alternate message file,")
   print ("                  defualt /usr/local/data/us-tx-cluster-1/MESSAGEHD")
   print ("\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display/tree/master/scrollphathd\n")
#  After displaying help in english check for other languages
   if LANGUAGE != "en_US.UTF-8" :
      print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Your language, {} is not supported, Would you like to help translate?".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), LANGUAGE))
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

#  Set fully qualified domain name
from socket import getfqdn
#
LOCALHOST = getfqdn()

#  Version  
with open(__file__) as f :
   f.readline()
   line2 = f.readline()
   line2 = line2.split()
   SCRIPT_NAME = line2[1]
   SCRIPT_VERSION = line2[2]

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
print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Begin".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid()))

#  DEBUG example
from platform import python_version
#
if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Version of python >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), python_version()))


# >>>	#40
#  Set default MESSAGEHD file with path
MESSAGEHD_file = "/usr/local/data/us-tx-cluster-1/MESSAGEHD"

#  Check argument 1 for non-default MESSAGEHD file
if no_arguments == 2 :
   MESSAGEHD_file = sys.argv[1]
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Using MESSAGEHD file >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), MESSAGEHD_file))
else :
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Using MESSAGEHD file >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), MESSAGEHD_file))

#  Read TEMP_FILE contents and return contents #41
def get_msg(TEMP_FILE) :
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Reading MESSAGE file >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), TEMP_FILE))
   file = open(TEMP_FILE,"r")
   CONTENT = file.read().splitlines()
   file.close()
   return CONTENT

### 
import signal
import scrollphathd
from scrollphathd.fonts import font3x5

scrollphathd.set_clear_on_exit()
#  Rotate the text
scrollphathd.rotate(180)
#  Set brightness
scrollphathd.set_brightness(0.2)
#  If rewind is True the scroll effect will rapidly rewind after the last line
# >>> oeg	rewind = True
rewind = False
#  Delay is the time (in seconds) between each pixel scrolled
delay = 0.03
#  Determine how far apart each line should be spaced vertically
line_height = scrollphathd.DISPLAY_HEIGHT + 2
#
while True:
   #  Store the left offset for each subsequent line (starts at the end of the last line)
   offset_left = 0
   #  Get message from MESSAGEHD file created by create-message.sh
   lines = get_msg(MESSAGEHD_file)
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Show lines >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), lines))  #25
   #  Code from Pimoroni scrollphathd/examples/advanced-scrolling.py
   #  Draw each line in lines to the Scroll pHAT HD buffer
   #  scrollphathd.write_string returns the length of the written string in pixels
   #  we can use this length to calculate the offset of the next line
   #  and will also use it later for the scrolling effect.
   lengths = [0] * len(lines)
   #  
   scrollphathd.fill(0,0,0)  #25
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  Before 'for' loop;  lengths >{}<  offset_left >{}<  line_height >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), lengths, offset_left, line_height))  #25
   for line, text in enumerate(lines):
      lengths[line] = scrollphathd.write_string(text, x=offset_left, y=line_height * line)
      offset_left += lengths[line]
   if DEBUG == 1 : print ("{}{} {} {} {} {}[DEBUG]{}  {}  {}  {} {}  After 'for' loop;  lengths >{}<  offset_left >{}<  line_height >{}<".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid(), lengths, offset_left, line_height))  #25
   #  This adds a little bit of horizontal/vertical padding into the buffer at
   #  the very bottom right of the last line to keep things wrapping nicely.
   scrollphathd.set_pixel(offset_left - 1, (len(lines) * line_height) - 1, 0)
   #  Reset the animation
   scrollphathd.scroll_to(0, 0)
   scrollphathd.show()
   #  Keep track of the X and Y position for the rewind effect
   pos_x = 0
   pos_y = 0
   for current_line, line_length in enumerate(lengths):
      #  Delay a slightly longer time at the start of each line
      #
      # >>> org      time.sleep(delay*10)
      time.sleep(delay*30)
      #  Scroll to the end of the current line
      for y in range(line_length):
         scrollphathd.scroll(1, 0)
         pos_x += 1
         time.sleep(delay)
         scrollphathd.show()
      #  If we're currently on the very last line and rewind is True
      #  We should rapidly scroll back to the first line.
      if current_line == len(lines) - 1 and rewind:
         for y in range(pos_y):
            scrollphathd.scroll(-int(pos_x/pos_y), -1)
            scrollphathd.show()
            time.sleep(delay)
      #  Otherwise, progress to the next line by scrolling upwards
      else:
         for x in range(line_height):
            scrollphathd.scroll(0, 1)
            pos_y += 1
            scrollphathd.show()
            time.sleep(delay)

#  Done
print ("{}{} {} {} {} {}[INFO]{}  {}  {}  {} {}  Done.".format(color.END, get_date_stamp(), __file__, SCRIPT_VERSION, get_line_no(), color.BOLD, color.END, LOCALHOST, os.getlogin(), os.getuid(), os.getgid()))
###
