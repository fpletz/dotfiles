#!/bin/bash

fbsetbg -l &
/home/fpletz/.cabal/bin/xmobar &

#xscreensaver -nosplash &
xcompmgr &
xrdb -load $HOME/.Xdefaults &

xset dpms force on &
#xset s off
xset b off &

xmodmap ~/.us-intl-de.xmodmap

xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200 &

if [ -e /etc/debian_version ] ; then
	exec /home/fpletz/.cabal/bin/xmonad
else
	export WINDOW_MANAGER=xmonad
	exec gnome-session
fi
