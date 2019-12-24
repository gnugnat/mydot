#!/bin/sh

#       _       _ _
# __  _(_)_ __ (_) |_ _ __ ___
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__
# /_/\_\_|_| |_|_|\__|_|  \___|

### Usage:
# $ startx ~/.xinitrc [session]

### Source xprofile
#
[ -f "$HOME/.xprofile" ] && . ~/.xprofile

### Source additional X scripts
#
# ex.: xrandr settings
[ -f "$HOME/.xscripts" ] && . ~/.xscripts

### Start the session
#
# Here JWM is kept as default
session=${1:-jwm}
#
case $session in
    bsp|bspwm	) exec bspwm;;
    exwm|EXWM	)
	exec emacs --load ~/.emacs.d/exwm-config.el
	;;
    gnome	) exec gnome-session;;
    lxqt|LXQt   ) exec startlxqt;;
    kde		) exec startplasma-x11;;
    mate	) exec mate-session;;
    xfce|xfce4	) exec startxfce4;;
    # Anything different is run as command
    *		) exec $1;;
esac
