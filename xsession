#!/bin/bash

xcompmgr &
xrdb -load $HOME/.Xdefaults

xset dpms force on
xset s off
xset -b b off

#synclient TapButton1=1 TapButton2=2 TapButton3=3 &

# caps lock ist doof
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"

fbsetbg -l

# systray
#trayer --edge top --align right --SetDockType true --SetPartialStrut true \
# --expand true --width 5 --transparent true --tint 0x202020 --height 12 &

#x-terminal-emulator &

exec xmonad

