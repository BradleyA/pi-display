#!/usr/bin/env python
# 	scrollphathd/display-scrollphathd-test.py  3.321.507  2019-01-12T16:03:37.083500-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.320  
# 	   template.[sh,py] production standard 4 change display_help of other LANG 
# 	plasma-1.py  3.88.202  2018-08-31_22:26:52_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.87  
# 	   update display_help 
# 	plasma-1.py  3.87.201  2018-08-31_22:15:06_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.86  
# 	   start filling in display_help 
# 	plasma-1.py  3.86.200  2018-08-31_21:53:47_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.85  
# 	   begin merging standard py format 
# 	plasma.py  3.78.192  2018-08-21_22:24:06_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.77  
# 	   start design and deveopment of scrollphathd/ #22 
###
import sys
import time
import os
import math
import scrollphathd
###
class color:
    BOLD = '\033[1m'
    END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():
    print "\n", __file__, "- ten second Scroll pHAT HD screen test"
    print "\nUSAGE\n   ", __file__,
    print "\n   ", __file__, "[--help | -help | help | -h | h | -? | ?]"
    print "   ", __file__, "[--version | -version |-v]"
    print "\nDESCRIPTION"
#   Displaying help DESCRIPTION in English en_US.UTF-8
    print "<<your help output goes here>>"
    print "... Pimoroni Scroll pHAT HD 17x7 Pixels Display for Raspberry Pi ..."
    print "... used plasma.py command from scrollphathd/exaples directory ..."
    print "\nAdded follow line using administrator account with crontab -e;"
    print "   @reboot /usr/local/bin/plasma-1.py >> /tmp/crontab-test-log-file 2>&1 ..."
#       Displaying help DESCRIPTION in French
    if (LANGUAGE == "fr_CA.UTF-8") or (LANGUAGE == "fr_FR.UTF-8") or (LANGUAGE == "fr_CH.UTF-8"):
        print("\n--> {}".format(LANGUAGE))
        print("<votre aide va ici>")
        print("Souhaitez-vous traduire la section description?")
    elif (LANGUAGE != "en_US.UTF-8"):
        print color.END,__file__,get_line_no(),color.BOLD,"[WARNING]",color.END,"Your language,", LANGUAGE, "is not supported, Would you like to help translate the description section?"
    print "\nOPTIONS\n   None"
    print "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display"
    return
#
from inspect import currentframe
def get_line_no():
    cf = currentframe()
    return cf.f_back.f_lineno
#
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
            print line2[1], line2[2]
        sys.exit()
###

i = 0

for count in range(265):
    i += 2
    s = math.sin(i / 50.0) * 2.0 + 6.0

    for x in range(0, 17):
        for y in range(0, 7):
            v = 0.3 + (0.3 * math.sin((x * s) + i / 4.0) * math.cos((y * s) + i / 4.0))

            scrollphathd.pixel(x, y, v)

    time.sleep(0.01)
    scrollphathd.show()
