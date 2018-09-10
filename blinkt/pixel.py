#!/usr/bin/env python
# 	pixel.py  3.09.86  2018-06-24_22:25:49_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.08  
# 	   completed prototype controling blinkt from container start with docker-compose 
from blinkt import set_clear_on_exit, set_pixel, show

import time

set_clear_on_exit()
set_pixel(0, 255, 0, 0)
show()


time.sleep(1) # 1 = 1 second
for x in range(0, 8):
    print("This is value " + str(x))
