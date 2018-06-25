#!/usr/bin/env python
# 	../../../display-led.py  3.09.86  2018-06-24_22:25:49_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.08  
# 	   completed prototype controling blinkt from container start with docker-compose 
# 	display-led.py  3.08.85  2018-03-14_21:59:15_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.07-2-g5f6290c  
# 	   added more prices, first draft of display-led.py 
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
CLUSTER = "cluster-1/"
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

#       VIOLET : the statistic is  WARNING (alert)
#   LED_number argument 0-7
def status6(LED_number):
    set_pixel(LED_number, 127, 0, 255, 0.1)
    show()
    time.sleep(15) # 1 = 1 second

#   process information
def process(line):
    print("this is in the process information function")
    print(line)
    if 'celsius:' in line.lower():
        print("---> this is Celsius: <---")
        print ("celsius: ->")
        print("yy")
    print("---> not Celsius:")
    print("xx")

#####
#   read file and process information
# >>>  need to replace path and file name with variables
with open('/usr/local/data/cluster-1/two-rpi3b.cptx86.com') as f:
    print  FILE_NAME
    print("begin for loop")
    for line in f:
        print("this is in the for loop")
        print(line)
        process(line)

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
status6(6)
status6(7)

    
#		###
