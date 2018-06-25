#!/usr/bin/env python
# 	rainbow.py  3.09.86  2018-06-24_22:25:49_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.08  
# 	   completed prototype controling blinkt from container start with docker-compose 

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
        set_pixel(x,r,g,b)
    show()
    time.sleep(0.001)
set_all(0,0,0)
