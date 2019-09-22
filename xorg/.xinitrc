#!/bin/sh

#       _       _ _
# __  _(_)_ __ (_) |_ _ __ ___
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__
# /_/\_\_|_| |_|_|\__|_|  \___|

### Usage:
# $ startx ~/.xinitrc [session]

### Stuff outside of ~/.xprofile
#
exec_additional(){
    mpd &
    compton -b &
    ~/.fehbg &
    dunst &
    /usr/libexec/polkit-gnome-authentication-agent-1 &
    udiskie -at &
    nm-applet &
    pasystray &
    xfce4-power-manager &
    xss-lock -- i3lock -c 000000 &
}

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
	exec_additional
	exec emacs
	;;
    gnome	) exec gnome-session;;
    i3		) exec i3;;
    jwm		) exec jwm;;
    kde		) exec startkde;;
    mate	) exec mate-session;;
    xfce|xfce4	) exec startxfce4;;
    # Anything different is run as command
    *		) exec $1;;
esac
