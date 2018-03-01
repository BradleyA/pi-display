#!/usr/bin/python

#       First, we'll clear any pixels that might be lit already,
#       then set the leftmost pixel white, and finally call show()
#       to display the pixel we set on Blinkt!.
#

from blinkt import set_pixel, set_brightness, show, clear
import colorsys
import time

j = 1
i = 0

#       set the brightness fairly low, at 0.1, since full brightness is really bright.
set_brightness(0.1)

print ("blinkt")
clear()
set_pixel(0, 255, 255, 255)
set_pixel(1, 0, 0, 255)
set_pixel(2, 0, 255, 0)
set_pixel(3, 255, 255, 0)
set_pixel(6, 255, 0, 0)
set_pixel(7, 255, 0, 255)
show()

time.sleep(5.05)

for j in range(50):
  for i in range(8):
    clear()
    set_pixel(i, 255, 0, 0)
    show()
    time.sleep(0.05)

time.sleep(5.05)

spacing = 360.0 / 16.0

hue = 0
x = 0

while True:
    hue = int(time.time() * 100) % 360
    for x in range(8):
        offset = x * spacing
        h = ((hue + offset) % 360) / 360.0
        r, g, b = [int(c * 255) for c in colorsys.hsv_to_rgb(h, 1.0, 1.0)]
        set_pixel(x, r, g, b)
    show()
    time.sleep(0.001)

