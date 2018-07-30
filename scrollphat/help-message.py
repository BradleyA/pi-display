#!/usr/bin/env python
# 	help-message.py  3.65.176  2018-07-29_21:56:49_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.64  
# 	   added LANG support for display_help 
# 	help-message.py  3.64.175  2018-07-29_20:51:00_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.63  
# 	   test works --version -version version -v #15 
# 	help-message.py  3.63.174  2018-07-29_19:11:04_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.62  
# 	   test works for --help -help help -h h -? ? #15 
# 	help-message.py  3.62.173  2018-07-29_19:07:08_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.61  
# 	   test works for --help -help help -h h -? ? 
# 	help-message.py  3.61.172  2018-07-29_17:35:05_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.60  
# 	   cleanup file after completing #18 to continue with #19 
# 	help-message.py  3.60.171  2018-07-29_17:25:31_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.59  
# 	   Completed design of ERROR WARNING INFO message for python close #18 
# 	help-message.py  3.57.168  2018-07-28_15:42:23_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.56  
# 	   test works -h  does not work --help -help help h -? ? #15 
# 	help-message.py  3.56.167  2018-07-28_14:59:59_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.55-1-gff92252  
# 	   begin design on py help processing 
#
###
import subprocess
import sys
import time
import os

###
def display_help():
   language = os.getenv("LANG")
   print "\n", __file__, "- <one line description>"
   print "\nUSAGE\n  ", __file__, "[xxx | yyy | zzz]"
   print "  ", __file__, "[--help | -help | help | -h | h | -? | ?] [--version | -v]"
   print "\nDESCRIPTION\n<<your help output goes here>>"
   print "\nOPTIONS\n   <<your options go here>>"
   print "\nDOCUMENTATION\n   <<URL to GITHUB README>>"
   print "\nEXAMPLES\n   <<your code examples go here>>"
   print "      <<line two of first example>>"
   if language != "en_US.UTF-8" :
      print color.END,__file__,get_line_no(),color.BOLD,"[WARNING]",color.END,"Your language,", language, "is not supported, Would you like to help?"
   return

print "command with path =", __file__
print "module =", __name__

from os import getcwd
print "pwd =", getcwd()

from inspect import currentframe
def get_line_no():
    cf = currentframe()
    return cf.f_back.f_lineno

class color:
   BOLD = '\033[1m'
   END = '\033[0m'

#	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]: ${USER} does NOT have write permission\n\tin local Git repository directory `pwd`"      1>&2
print color.END,__file__,get_line_no(),color.BOLD,"[ERROR]",color.END,"USER don't do that!\n"

###
if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?' or sys.argv[1] == '?' :
   display_help()
   sys.exit()
if sys.argv[1] == '--version' or sys.argv[1] == '-version' or sys.argv[1] == 'version' or sys.argv[1] == '-v' :
   with open(__file__) as f:
      f.readline()
      line2 = f.readline()
      line2 = line2.split()
      print line2[1], line2[2]
   sys.exit()
###
#
print "command with path =", __file__
print "module =", __name__

from os import getcwd

print "pwd =", getcwd()
#	review github incident #15
print "\nNumber of arguments:", len(sys.argv), "arguments."
print "Argument List:", str(sys.argv)

print "first argument =", sys.argv[1]

