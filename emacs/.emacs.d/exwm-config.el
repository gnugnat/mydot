;;; EXWM --- configuration
;;; Commentary:
;;
;; Copyright (c) 2020, XGQT
;; Licensed under the ISC License
;;
;;  _______  ____        ____  __
;; | ____\ \/ /\ \      / /  \/  |
;; |  _|  \  /  \ \ /\ / /| |\/| |
;; | |___ /  \   \ V  V / | |  | |
;; |_____/_/\_\   \_/\_/  |_|  |_|
;;
;; this file is loaded by .xinit
;; when executing
;;	"startx ~/.xinitrc exwm"
;; load it with
;;	"emacs --load ~/.emacs.d/exwm-config.el"

;;; Code:
(use-package exwm
  :ensure t
  :config

  ;; manual configuration
  (require 'exwm-config)

  ;; fringe size
  (fringe-mode 10)

  ;; create clock
  (setq display-time-24hr-format t
	display-time-format "%H:%M %d %b")
  (display-time-mode 1)

  ;; make sure dashboard shows up
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

  ;; super-t to launch vterm
  (global-set-key (kbd "s-t") 'vterm)

  ;; only enable the connected external screen
  (require 'exwm-randr)
  (defun exwm-change-screen-hook ()
    (let ((xrandr-output-regexp "\n\\([^ ]+\\) connected ")
	  default-output)
      (with-temp-buffer
	(call-process "xrandr" nil t nil)
	(goto-char (point-min))
	(re-search-forward xrandr-output-regexp nil 'noerror)
	(setq default-output (match-string 1))
	(forward-line)
	(if (not (re-search-forward xrandr-output-regexp nil 'noerror))
	    (call-process "xrandr" nil nil nil "--output" default-output "--auto")
	  (call-process
	   "xrandr" nil nil nil
	   "--output" (match-string 1) "--primary" "--auto"
	   "--output" default-output "--off")
	  (setq exwm-randr-workspace-output-plist (list 0 (match-string 1))))))
    ;; set the wallpaper (with feh)
    (start-process-shell-command
     "feh" nil "sh -c '[ -f $HOME/.fehbg ] && $HOME/.fehbg'")
    )
  (add-hook 'exwm-randr-screen-change-hook 'exwm-change-screen-hook)
  (exwm-randr-enable)

  ;; rename buffers to window title
  (defun exwm-rename-buffer-to-title ()
    (exwm-workspace-rename-buffer exwm-title))
  (add-hook 'exwm-update-title-hook 'exwm-rename-buffer-to-title)

  ;; systray
  (require 'exwm-systemtray)
  (exwm-systemtray-enable)

  ;; workspaces
  (setq exwm-workspace-number 10
	exwm-workspace-show-all-buffers nil
	exwm-layout-show-all-buffers nil)

  ;; bind s-<number> to switch to the corresponding workspace
  (dotimes (i 10)
    (exwm-input-set-key (kbd (format "s-%d" i))
			`(lambda ()
			   (interactive)
			   (exwm-workspace-switch-create ,i))))

  ;; rebind essential GUI keys
  (exwm-input-set-simulation-keys
   '(
     ;; movement
     ([?\C-b] . left)
     ([?\M-b] . C-left)
     ([?\C-f] . right)
     ([?\M-f] . C-right)
     ([?\C-p] . up)
     ([?\C-n] . down)
     ([?\M-v] . prior)
     ([?\C-v] . next)
     ([?\C-k] . (S-end delete))
     ;; cut/paste
     ([?\C-w] . ?\C-x)
     ([?\M-w] . ?\C-c)
     ([?\C-y] . ?\C-v)
     ;; search
     ([?\C-s] . ?\C-f)
     ))

  (setq exwm-input-global-keys
	'(

	  ;; exit char-mode and fullscreen mode
	  ([?\s-r] . exwm-reset)

	  ;; switch workspace interactively
	  ([?\s-w] . exwm-workspace-switch)

	  ;; "s-<f2>" to lock screen
	  ([s-f2] . (lambda ()
		      (interactive)
		      (start-process-shell-command
		       "xset" nil "xset s activate")))
	  ))

  ;; Switch to last open buffer
  (defun switch-to-last-buffer()
    "Switch to last open buffer in current window"
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer) 1)))
  (exwm-input-set-key (kbd "s-<tab>") #'switch-to-last-buffer)

  ;;; Fn keys
  ;;
  ;; audio
  (exwm-input-set-key (kbd "<XF86AudioRaiseVolume>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "pactl" nil "pactl set-sink-volume $(pactl list short sinks | grep RUNNING | cut -f1) +2%")))
  (exwm-input-set-key (kbd "<XF86AudioLowerVolume>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "pactl" nil "pactl set-sink-volume $(pactl list short sinks | grep RUNNING | cut -f1) -2%")))
  (exwm-input-set-key (kbd "<XF86AudioMute>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "pactl" nil "pactl set-sink-mute $(pactl list short sinks | grep RUNNING | cut -f1) toggle")))
  ;;
  ;; mpd
  (exwm-input-set-key (kbd "<XF86AudioPrev>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "mpc" nil "mpc prev")))
  (exwm-input-set-key (kbd "<XF86AudioNext>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "mpc" nil "mpc next")))
  (exwm-input-set-key (kbd "<XF86AudioPlay>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "mpc" nil "mpc toggle")))
  (exwm-input-set-key (kbd "<XF86AudioStop>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "mpc" nil "mpc stop")))
  ;;
  ;; camera
  (exwm-input-set-key (kbd "<XF86Display>")
		      (lambda ()
			(interactive)
			(start-process-shell-command
			 "mpv" nil "mpv /dev/video0")))

  ;; simple launcher
  (exwm-input-set-key (kbd "<s-return>")
		      (lambda (command)
			(interactive (list (read-shell-command "» ")))
			(start-process-shell-command command nil command)))

  ;; start some programs
  ;;	if this file is re-loaded those programs will not start
  ;;	because they are added to emacs-startup-hook
  (add-hook 'emacs-startup-hook (lambda ()
				  (start-process-shell-command "" nil "compton -b &")
				  (start-process-shell-command "" nil "dunst &")
				  (start-process-shell-command "" nil "/usr/libexec/polkit-gnome-authentication-agent-1 &")
				  (start-process-shell-command "" nil "mpd &")
				  (start-process-shell-command "" nil "udiskie -at &")
				  (start-process-shell-command "" nil "nm-applet &")
				  (start-process-shell-command "" nil "pasystray &")
				  (start-process-shell-command "" nil "xfce4-power-manager &")
				  (start-process-shell-command "" nil "xss-lock -- i3lock -c 000000 &")
				  ))

  ;; enable
  (exwm-enable)
  )
;;; exwm-config.el ends here
