#!/usr/bin/env python
# 	display-message-hd.py  3.98.228  2018-09-09_20:55:05_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.97  
# 	   change spacing; cut code for reread date file at the beginning of each loop #25 
# 	display-message-hd.py  3.92.222  2018-09-03_19:36:28_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.91  
# 	   FINALLY got the damn MESSAGE fro scroll in advanced close #22 
###
DEBUG = 0       # 0 = debug off, 1 = debug on
#
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
   print ("\n{} - display contents of MESSAGEHD file".format(__file__))
   print ("\nUSAGE\n  {} [<MESSAGEHD_file>]".format(__file__))
   print ("  {} [--help | -help | help | -h | h | -? | ?]".format(__file__))
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
   if language != "en_US.UTF-8" :
      print ("{}{} {} {}[WARNING]  Your language, {} is not supported, Would you like to help?".format(color.END,__file__,get_line_no(),color.BOLD,color.END))
   return
#  line number function
from inspect import currentframe
def get_line_no():
   cf = currentframe()
   return cf.f_back.f_lineno
#  default help and version arguments
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
         print ("{} {}".format(line2[1], line2[2]))
      sys.exit()
###
if DEBUG == 1 : print ("> {}DEBUG{} {}  Name_of_command >{}<".format(color.BOLD,color.END,get_line_no(),__file__))
#  set default MESSAGEHD file with path
MESSAGEHD_file = "/usr/local/data/us-tx-cluster-1/MESSAGEHD"
#  Check argument 1 for non-default MESSAGEHD file
if no_arguments == 2 :
   MESSAGEHD_file = sys.argv[1]
   print ("\n{}{} {} {}[INFO]{} Using MESSAGEHD file {}".format(color.END,__file__,get_line_no(),color.BOLD,color.END,MESSAGEHD_file))
else :
   print ("\n{}{} {} {}[INFO]{} Using MESSAGEHD file {}".format(color.END,__file__,get_line_no(),color.BOLD,color.END,MESSAGEHD_file))
#
def get_msg():
   with open(MESSAGEHD_file,"r") as file:
      temp = file.read().splitlines()
      if DEBUG == 1 : print ("> {}DEBUG{} {}  File contents >{}<".format(color.BOLD,color.END,get_line_no(),temp))
   return temp
#  Rotate the text
scrollphathd.rotate(180)
#  Set brightness
scrollphathd.set_brightness(0.2)
#  If rewind is True the scroll effect will rapidly rewind after the last line
rewind = True
#  Delay is the time (in seconds) between each pixel scrolled
delay = 0.03
#  Determine how far apart each line should be spaced vertically
line_height = scrollphathd.DISPLAY_HEIGHT + 2
#  Store the left offset for each subsequent line (starts at the end of the last line)
offset_left = 0
#
###
# >>>	#25 display-message-hd.py reread date file at the beginning of each loop #25
###
while True:
   #  Get message from MESSAGEHD file created by create-message.sh
   lines = get_msg()
   if DEBUG == 1 : print ("> {}DEBUG{} {}  Show lines {}".format(color.BOLD,color.END,get_line_no(),lines))
   #  Code from Pimoroni scrollphathd/examples/advanced-scrolling.py
   #  Draw each line in lines to the Scroll pHAT HD buffer
   #  scrollphathd.write_string returns the length of the written string in pixels
   #  we can use this length to calculate the offset of the next line
   #  and will also use it later for the scrolling effect.
   lengths = [0] * len(lines)
   for line, text in enumerate(lines):
      lengths[line] = scrollphathd.write_string(text, x=offset_left, y=line_height * line)
      offset_left += lengths[line]
      if DEBUG == 1 : print ("> {}DEBUG{} {}  START for line loop {}  ->{}<-".format(color.BOLD,color.END,get_line_no(),line,lengths[line]))
   #  This adds a little bit of horizontal/vertical padding into the buffer at
   #  the very bottom right of the last line to keep things wrapping nicely.
   scrollphathd.set_pixel(offset_left - 1, (len(lines) * line_height) - 1, 0)
#
# >>>	#25	while True:
   #  Reset the animation
   scrollphathd.scroll_to(0, 0)
   scrollphathd.show()
   #  Keep track of the X and Y position for the rewind effect
   pos_x = 0
   pos_y = 0
   for current_line, line_length in enumerate(lengths):
   #  Delay a slightly longer time at the start of each line
      time.sleep(delay*10)
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
###
