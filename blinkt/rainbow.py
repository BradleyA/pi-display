#!/usr/bin/env python
# 	rainbow.py  2.7.39  2018-02-27_18:52:21_CST  https://github.com/BradleyA/pi-display-board  uadmin  two-rpi3b.cptx86.com 2.6-1-ge4f399b  
# 	   moved this test cases to github 
#	rainbow.py	1.0	2017-12-19_13:25:32_CST uadmin
#	copy from Blinkt https://github.com/pimoroni/blinkt

import colorsys
import time

from blinkt import set_clear_on_exit, set_brightness, set_pixel, show


spacing = 360.0 / 16.0
hue = 0

set_clear_on_exit()
set_brightness(0.1)

while True:
    hue = int(time.time() * 100) % 360
    for x in range(8):
        offset = x * spacing
        h = ((hue + offset) % 360) / 360.0
        r, g, b = [int(c*255) for c in colorsys.hsv_to_rgb(h, 1.0, 1.0)]
        print x, r, g, b
        set_pixel(x,r,g,b)
    show()
    time.sleep(1.001)
