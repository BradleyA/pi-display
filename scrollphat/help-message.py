#!/usr/bin/env python
# 	help-message.py  3.59.170  2018-07-29_13:30:07_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.58  
# 	   getting close with #18 ERROR WARNING INFO stdout:wq 
# 	help-message.py  3.58.169  2018-07-28_16:12:24_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.57  
# 	   #15 
# 	help-message.py  3.57.168  2018-07-28_15:42:23_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.56  
# 	   test works -h  does not work --help -help help h -? ? #15 
# 	help-message.py  3.56.167  2018-07-28_14:59:59_CDT  https://github.com/BradleyA/pi-display  uadmin  three-rpi3b.cptx86.com 3.55-1-gff92252  
# 	   begin design on py help processing 

###
import subprocess
import sys
import time


def display_help():
    print("<<your help output goes here>>")
#	need to change to python from bash echo -e "\n${0} - remote cluster system adminstration tool"
#    sys.exit(1)

print __name__, 'line number '
print __file__
import os
cwd = os.getcwd()
print 'cwd = ', cwd

from inspect import currentframe

def get_linenumber():
    cf = currentframe()
    return cf.f_back.f_lineno

print "This is line 32, python says line ", get_linenumber()


#	import os.path

#	print 'function call = ', sys._getframe().f_code.co_filename
#	file_name =  sys._getframe().f_code.co_filename
#	print 'file_name = ', file_name
#	print 'function call =',  os.path.abspath()
#	file_name_path = os.path.abspath()
#	print 'file_name_path = ', os.path.abspath()
#	
#	
#	
#	review github incident #15
print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)
###	if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
###	        display_help
###	        exit 0
###	fi
###	if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] ||  [ "$1" == "-v" ] ; then
###	        head -2 ${0} | awk {'print$2"\t"$3'}
###	        exit 0
###	fi

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

