#!/usr/bin/env python3
# 	blinkt/display-led-test.py  3.372.562  2019-01-23T21:36:59.212435-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.371  
# 	   first pass to add production standards 
# 	blinkt/display-led-test.py  3.371.561  2019-01-23T21:13:33.503303-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.370  
# 	   adjust timimg 
# 	blinkt/display-led-test.py  3.369.559  2019-01-23T20:42:21.093603-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.368  
# 	   added led color test during start 
# 	blinkt/display-led-test.py  3.271.430  2019-01-03T14:49:30.532723-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.270  
# 	   rename scrollphat.test.py to display-scrollphat-test.py 
# 	larson-1.py  3.175.317  2018-09-29_21:47:03_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.174  
# 	   add green after red 
# 	larson-1.py  3.174.316  2018-09-29_21:36:57_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.173  
# 	   include larson-1.py 
### display-led-test.py - from larson.py
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#   production standard 5
import math
import time
import colorsys
from blinkt import set_clear_on_exit, set_pixel, show, set_brightness
#       Order of precedence: environment variable (export DEBUG=1), default code
DEBUG = int(os.getenv("DEBUG", 0)) #  Set DEBUG,  0 = debug off, 1 = debug on, 'unset DEBUG' to unset environment variable (bash)
###
class color:
    BOLD = '\033[1m'
    END = '\033[0m'
###
LANGUAGE = os.getenv("LANG")
def display_help():


#
set_clear_on_exit()

reds = [0, 0, 0, 0, 0, 16, 64, 255, 64, 16, 0, 0, 0, 0, 0]

start_time = time.time()

for count in range(93):
    delta = (time.time() - start_time) * 16

    # Sine wave, spends a little longer at min/max
    # offset = int(round(((math.sin(delta) + 1) / 2) * 7))

    # Triangle wave, a snappy ping-pong effect
    offset = int(abs((delta % 16) - 8))

    for i in range(8):
        set_pixel(i , reds[offset + i], 0, 0)
    show()

    time.sleep(0.1)

for count in range(47):
    delta = (time.time() - start_time) * 16

    # Sine wave, spends a little longer at min/max
    # offset = int(round(((math.sin(delta) + 1) / 2) * 7))

    # Triangle wave, a snappy ping-pong effect
    offset = int(abs((delta % 16) - 8))

    for i in range(8):
        set_pixel(i , 0, reds[offset + i], 0)
    show()

    time.sleep(0.1)

set_brightness(0.1)

spacing = 360.0 / 16.0
hue = 0
x = 0
j = 1

for j in range(3500):
    hue = int(time.time() * 100) % 360
    for x in range(8):
        offset = x * spacing
        h = ((hue + offset) % 360) / 360.0
        r, g, b = [int(c * 255) for c in colorsys.hsv_to_rgb(h, 1.0, 1.0)]
        set_pixel(x, r, g, b)
    show()
    time.sleep(0.001)

