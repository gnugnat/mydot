# Usage:
# $ startx ~/.xinitrc [session]

# Keyboard:
#
# Polish + hold caps=control
setxkbmap pl -option "caps:ctrl_modifier"
#
# caps=escape
xcape -e "Caps_Lock=Escape"

# Start the session:
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
