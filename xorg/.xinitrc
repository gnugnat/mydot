#!/bin/sh

#       _       _ _
# __  _(_)_ __ (_) |_ _ __ ___
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__
# /_/\_\_|_| |_|_|\__|_|  \___|

### Usage:
# $ startx ~/.xinitrc [session]

### Source xprofile:
[ -f "$HOME/.xprofile" ] && . ~/.xprofile

### Start the session:
#
# Here JWM is kept as default
session=${1:-jwm}
#
case $session in
    i3		) exec i3;;
    jwm		) exec jwm;;
    mate	) exec mate-session;;
    xfce|xfce4	) exec startxfce4;;
    kde		) exec startkde;;
    gnome	) exec gnome-session;;
    # Anything different is run as command
    *		) exec $1;;
esac
