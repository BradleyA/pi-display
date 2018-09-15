#!/usr/bin/env python
# 	scrollphat.test.py  3.109.251  2018-09-15_11:10:15_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.108  
# 	   begin changing scroll-phat/examples/test-all.py for screen test 
###
DEBUG = 0       # 0 = debug off, 1 = debug on
#
import subprocess
import sys
import time
import os
#
import math
import scrollphat
###
class color:
   BOLD = '\033[1m'
   END = '\033[0m'
###
def display_help():
   LANGUAGE = os.getenv("LANG")
   print ("\n{} - ten second Scroll pHAT screen test".format( __file__))
   print ("\nUSAGE\n   {} [xxx | yyy | zzz]".format(__file__))
   print ("   {} [--help | -help | help | -h | h | -? | ?]".format(__file__))
   print ("   {} [--version | -version | -v]".format(__file__))
   print ("\nDESCRIPTION\n<<your help output goes here>>")
   print ("Modified Pimoroni scroll-phat/examples/test-all.py and renamed scrollphat.test.py")
   print ("for Raspberry Pi.")
   print ("\nDOCUMENTATION\n    https://github.com/BradleyA/pi-display")
   print ("\nEXAMPLES\n   <<your code examples description goes here>>")
   print ("   {} <<code example goes here>>\n".format(__file__))
#  After displaying help in english check for other languages
   if LANGUAGE != "en_US.UTF-8" :
      print ("{}{} {} {}[WARNING]{} Your language, {} is not supported, Would you like to help?".format(color.END,__file__,get_line_no(),color.BOLD,color.END,LANGUAGE))
   return
#  Line number function
from inspect import currentframe
def get_line_no():
   cf = currentframe()
   return cf.f_back.f_lineno
#  Default help and version arguments
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
#  DEBUG example
if DEBUG == 1 : print (">{} DEBUG{} {}  Name_of_command >{}<".format(color.BOLD,color.END,get_line_no(),__file__))
###
scrollphat.set_brightness(2)
#
def millis():
   return int(round(time.time() * 1000))
#
def set_checker(offset):
   n = offset
   for y in range(5):
      for x in range(11):
         scrollphat.set_pixel(x,y,n % 2 == 0)
         n += 1
   scrollphat.update()
#
PAUSE=0.2
for count in range(8):
      scrollphat.set_pixels(lambda x, y: 1, auto_update=True)
      time.sleep(PAUSE)
      scrollphat.set_pixels(lambda x, y: y % 2 == 0, auto_update=True)
      time.sleep(PAUSE)
      scrollphat.set_pixels(lambda x, y: x % 2 == 0, auto_update=True) 
      time.sleep(PAUSE)
      set_checker(0)
#      time.sleep(0.5)
      time.sleep(PAUSE)
      set_checker(1)
#      time.sleep(0.5)
      time.sleep(PAUSE)
#
scrollphat.clear()
sys.exit(-1)
###
