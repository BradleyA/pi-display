#!/usr/bin/env python
# 	ba-text.py  3.78.192  2018-08-21_22:24:06_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.77  
# 	   start design and deveopment of scrollphathd/ #22 

import signal

import scrollphathd
from scrollphathd.fonts import font3x5

scrollphathd.set_brightness(0.3)

scrollphathd.fill(1, 0, 0, 17, 7)

scrollphathd.write_string("   3 containers, 0 alerts, 0 warnings, 0 security updates, 0 updates, ...........", y=1, font=font3x5, brightness=0)

scrollphathd.show()

signal.pause()
