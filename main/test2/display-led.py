#!/usr/bin/env python
# 	display-led.py  3.26.125  2018-07-05_20:35:22_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.25  
# 	   celsius working as LED 7 
# 	display-led.py  3.25.124  2018-07-05_19:54:51_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.22-2-gd5dc5cb  
# 	   create celsius table for 1-5 
# 	display-led.py  3.22.121  2018-07-03_17:30:04_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.21  
# 	   add LOCAL-HOST link to local host data in /usr/local/data/cluster 
# 	../../../display-led.py  3.09.86  2018-06-24_22:25:49_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.08  
# 	   completed prototype controling blinkt from container start with docker-compose 
###
#	The final design should control an Blinkt LED bar and
#		display information for a second
#		So this means it will take 8 seconds to display all LEDS?
#	Each color level function will exit with the primary color on
#	Color brightness controlled in each color level function
#
#	Other containers will update a volume that this container mounts
#		and reads (LED_number, Level)
###

from blinkt import set_clear_on_exit, set_pixel, show, clear
import time
import subprocess

set_clear_on_exit()
# >>> #
CLUSTER = "cluster-1"
DATA_DIR = "/usr/local/data/"
FILE_NAME = subprocess.check_output("hostname -f", shell=True)
# >>> #
print  FILE_NAME
FILE_NAME = DATA_DIR + CLUSTER + FILE_NAME
print  FILE_NAME

def status1(LED_number):
#   Normal services and operations
#	GREEN : no known incidents
#   LED_number argument 0-7
    set_pixel(LED_number, 0, 255, 0, 0.2)
    show()
    return();

def status2(LED_number):
#   Incidents causing no disruption to overall services and operations
#	LIGHT GREEN : an incident (watch)
#   LED_number argument 0-7
    for i in range(0, 5):
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 50, 205, 50, 0.2)
        show()
        time.sleep(0.15) # 1 = 1 second
    return();
        
def status3(LED_number):
#  Active incident with minimal affect to overall services and operations
#	YELLOW : additional incidents WARNING (alert)
#   LED_number argument 0-7
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
    return();

def status4(LED_number):
#   Active emergency incidents causing significant impact to operations and possiable service disruptions
#	ORANGE : CRITICAL ERROR
#   LED_number argument 0-7
    for i in range(0,10):
        set_pixel(LED_number, 255, 255, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 35, 0, 0.1)
        show()
        time.sleep(0.05) # 1 = 1 second
    return();

def status5(LED_number):
#   Active emergency incidents causing multiple impaired operations amd unavoidable severe service disruptions
#	RED : Emergency Conditions : FATAL ERROR : 
#   LED_number argument 0-7
    for i in range(0,10):
        set_pixel(LED_number, 255, 35, 0, 0.8)
        show()
        time.sleep(0.05) # 1 = 1 second
        set_pixel(LED_number, 0, 0, 0, 0)
        show()
        time.sleep(0.03) # 1 = 1 second
        set_pixel(LED_number, 255, 0, 0, 0.2)
        show()
        time.sleep(0.05) # 1 = 1 second
    return();

#       VIOLET : the statistic is  WARNING (alert)
#   LED_number argument 0-7
def status6(LED_number):
    set_pixel(LED_number, 127, 0, 255, 0.1)
    show()
    time.sleep(2) # 1 = 1 second
    return();

#   process information
def process(line):
    print("in process information function")
    print(line)
    if 'celsius:' in line.lower():
        print("celsius: ->")
        print(line[line.find(':')+2:])
        VALUE = float(line[line.find(':')+2:])
        print(VALUE)
        LED_number = 7
        if   VALUE < 48.5 : # < 48.5 C 119.3  1
            status1(LED_number)
        elif VALUE < 59   : # < 59 C   138.2  2
            status2(LED_number)
        elif VALUE < 69.5 : # < 69.5 C 157.1  3
            status3(LED_number)
        elif VALUE < 80   : # < 80 C   176    4
            status4(LED_number)
        elif VALUE >= 80  :   # > 80 C 176    5
            status5(LED_number) 
#        print("yy")
#    print("---> not Celsius:")
#    print("xx")
    return();

#####
#   read file and process information
# >>>  need to replace path and file name with variables
with open('/usr/local/data/cluster-1/two-rpi3b.cptx86.com') as f:
    print  FILE_NAME
    print("begin for loop")
    for line in f:
#        print("in for loop")
#        print(line)
        process(line)
    print("end for loop")

# >>>  need to replace path and file name with variables
#    file = open(FILE_NAME,"r")
#    print file.read()
#    file_data = fp.readlines()
#    file.close()

#		while TRUE:
#		#   loop through leds on blinkt
#		    for LED in range(0,7):
#		#       if file-information(LED) == 1 then status1(LED)
#		       if 
#		


status1(0)
status2(1)
status3(2)
status4(3)
status5(4)
status6(5)
#   status6(6)
#   status6(7)

#		###
