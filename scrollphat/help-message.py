#!/usr/bin/env python
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

###
def display_help():
    print("<<your help output goes here>>")
    return

from inspect import currentframe

def get_line_no():
    cf = currentframe()
    return cf.f_back.f_lineno

class color:
   BOLD = '\033[1m'
   END = '\033[0m'

#	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]: ${USER} does NOT have write permission\n\tin local Git repository directory `pwd`"      1>&2
print color.END,__file__,get_line_no(),color.BOLD,"[ERROR]",color.END,"USER don't do that!\n"

print "command with path =", __file__
print "module =", __name__

from os import getcwd

print "pwd =", getcwd()

###
#	review github incident #15
print "\nNumber of arguments:", len(sys.argv), "arguments."
print "Argument List:", str(sys.argv)

###	if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
###	        display_help
###	        exit 0
###	fi
###	if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] ||  [ "$1" == "-v" ] ; then
###	        head -2 ${0} | awk {'print$2"\t"$3'}
###	        exit 0
###	fi
print "first argument =", sys.argv[1]

if sys.argv[1] == '--help' or sys.argv[1] == '-help' or sys.argv[1] == 'help' or sys.argv[1] == '-h' or sys.argv[1] == 'h' or sys.argv[1] == '-?' or sys.argv[1] == '?' :
   display_help()
   print 'test works -h  does not work --help -help help h -? ? '
   sys.exit()

import sys, getopt

def main(argv):
   inputfile = ''
   outputfile = ''
   try:
      opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
   except getopt.GetoptError:
      print 'test.py -i <inputfile> -o <outputfile>'
      sys.exit(2)
   for opt, arg in opts:
      print 'opt = ', opt
      if opt == '--help' or opt == '-help' or opt == 'help' or opt == '-h' or opt == 'h' or opt == '-?' or opt == '?' :
         display_help()
         print 'test works -h  does not work --help -help help h -? ? '
         sys.exit()
      elif opt in ("-i", "--ifile"):
         inputfile = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
   print 'Input file is "', inputfile
   print 'Output file is "', outputfile

if __name__ == "__main__":
   main(sys.argv[1:])

