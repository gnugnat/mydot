#!/bin/sh


#       _       _ _
# __  _(_)_ __ (_) |_ _ __ ___
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__
# /_/\_\_|_| |_|_|\__|_|  \___|


# Usage:
# $ startx ~/.xinitrc [session]


# Source files

# Xprofile
[ -f "$HOME/.xprofile" ] && . ~/.xprofile

# Additional X scripts
# ex.: xrandr settings
[ -f "$HOME/.xscripts" ] && . ~/.xscripts


# Start the session

# Here KDE is kept as default
session=${1:-kde}

case $session in
    bsp|bspwm )
        exec bspwm
        ;;
    exwm|EXWM )
        exec emacs --load ~/.emacs.d/exwm-config.el
        ;;
    gnome )
        exec gnome-session
        ;;
    lxqt|LXQt )
        exec startlxqt
        ;;
    kde )
        exec startplasma-x11
        ;;
    mate )
        exec mate-session
        ;;
    xfce|xfce4 )
        exec startxfce4
        ;;
    # Anything different is run as command
    * )
        exec "${1}"
        ;;
esac
