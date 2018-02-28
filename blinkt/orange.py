#!/usr/bin/env python
# 	orange.py  2.7.39  2018-02-27_18:52:21_CST  https://github.com/BradleyA/pi-display-board  uadmin  two-rpi3b.cptx86.com 2.6-1-ge4f399b  
# 	   moved this test cases to github 
#	orange.py	1.0	2017-12-19_13:16:37_CST uadmin
#	test orange colors on Blinkt

import colorsys
import time

from blinkt import set_clear_on_exit, set_brightness, set_pixel, show


set_clear_on_exit()
set_brightness(0.1)

g = 1

while True:
    for x in range(8):
        g = g + 1
        print x,g 
        set_pixel(x,255,g,0)
    show()
    time.sleep(6.001)
    set_pixel(2,0,0,0)
    show()
    time.sleep(1.001)
