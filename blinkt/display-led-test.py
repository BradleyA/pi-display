#!/usr/bin/env python3
# 	blinkt/display-led-test.py  3.271.430  2019-01-03T14:49:30.532723-06:00 (CST)  https://github.com/BradleyA/pi-display.git  uadmin  six-rpi3b.cptx86.com 3.270  
# 	   rename scrollphat.test.py to display-scrollphat-test.py 
# 	larson-1.py  3.175.317  2018-09-29_21:47:03_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.174  
# 	   add green after red 
# 	larson-1.py  3.174.316  2018-09-29_21:36:57_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.173  
# 	   include larson-1.py 
### display-led-test.py - from larson.py

import math
import time

from blinkt import set_clear_on_exit, set_pixel, show, set_brightness
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

