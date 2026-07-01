#!/bin/bash

# Reset options first to avoid stacking when re-applied after xrandr/fcitx restarts.
setxkbmap -option
setxkbmap us colemak \
    -option caps:swapescape \
    -option ctrl:swap_lalt_lctl \
    -option lv3:ralt_alt
#xmodmap ~/.config/.Xmodmap
xset r rate 250 30

