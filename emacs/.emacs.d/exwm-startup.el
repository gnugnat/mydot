;;; EXWM --- startup
;;; Commentary:
;; Start some programs
;; load this file with
;;	"emacs --load ~/.emacs.d/exwm-startup.el"
;;; Code:
(start-process-shell-command "" nil "compton -b &")
(start-process-shell-command "" nil "dunst &")
(start-process-shell-command "" nil "/usr/libexec/polkit-gnome-authentication-agent-1 &")
(start-process-shell-command "" nil "mpd &")
(start-process-shell-command "" nil "udiskie -at &")
(start-process-shell-command "" nil "nm-applet &")
(start-process-shell-command "" nil "pasystray &")
(start-process-shell-command "" nil "xfce4-power-manager &")
(start-process-shell-command "" nil "xss-lock -- i3lock -c 000000 &")
;;; exwm-startup.el ends here
