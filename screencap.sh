#!/bin/bash

# Capture screen
adb shell screencap | sed 's/\r$//' > /tmp/screen.raw

# Converts raw screen data to rgba file
tail -c +13 /tmp/screen.raw > /tmp/screen.rgba

# Crops and rotate the picture
# The crop is unaware of the screen rotation!
convert -size 1080x1920 -depth 8 -crop 100x200+130+1625 -rotate 90 /tmp/screen.rgba $1
