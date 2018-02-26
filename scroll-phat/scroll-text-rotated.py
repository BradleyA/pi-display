#!/usr/bin/env python
# 	scroll-text-rotated.py	2.3.32	2018-02-26_15:14:25_CST uadmin three-rpi3b.cptx86.com 2.2-9-gfd85103 
# 	   continue debug; remove debug echo, add -q to ssh and scp 


import sys
import time

import scrollphat


scrollphat.set_brightness(2)

if len(sys.argv) != 2:
    print("\nusage: python simple-text-scroll-rotated.py \"message\" \npress CTRL-C to exit\n")
    sys.exit(0)

scrollphat.set_rotate(True)
scrollphat.write_string(sys.argv[1], 11)

while True:
    try:
        scrollphat.scroll()
        time.sleep(0.1)
    except KeyboardInterrupt:
        scrollphat.clear()
        sys.exit(-1)
