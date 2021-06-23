;;; minor.el --- small tweaks that don't require packages.


;; This file is part of mydot.

;; mydot is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, version 3.

;; mydot is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with mydot.  If not, see <https://www.gnu.org/licenses/>.

;; Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
;; Licensed under the GNU GPL v3 License



;;; Commentary:

;; Some small tweaks that don't require packages.

;; Use with mydot: https://gitlab.com/xgqt/mydot



;;; Code:


(require 'autorevert)
(require 'elec-pair)
(require 'hl-line)
(require 'paren)
(require 'prog-mode)


;; Pass "y or n" instead of "yes or no"
(defalias 'yes-or-no-p 'y-or-n-p)

;; Use tabs as spaces
(setq-default indent-tabs-mode nil)

;; Column number display in the mode line
(setq column-number-mode t)

;; disable lock files:
(setq create-lockfiles nil)

;; disable autosave:
(setq auto-save-default nil)

;; backups directory
;;(setq backup-directory-alist '(("" . (w-u-e-d "backup"))))

;; no "bell" (audible notification):
(setq ring-bell-function 'ignore)

;; Scrolling
(setq scroll-conservatively 100)

;; Disable backups
(setq make-backup-files nil)

;; Disable clipboard
(setq x-select-enable-clipboard-manager nil)

;; Don't use mouse selection in a GUI terminal
(setq xterm-mouse-mode nil)

;; Specal symbols
(defun laod-prettify-symbols ()
  "Enable 'global-prettify-symbols-mode'."
  (interactive)
  (setq
   prettify-symbols-alist
   '(
     ("and"    . "∧")
     ("lambda" . "λ")
     ("nil"    . "∅")
     ("or"     . "∨")
     ("sum"    . "∑")
     )
   )
  (prettify-symbols-mode t)
  )
(when window-system
  (add-hook 'prog-mode-hook 'laod-prettify-symbols)
  (add-hook 'comint-mode-hook 'laod-prettify-symbols)
  )

;; Size in GUI
(when window-system
  (set-frame-size (selected-frame) 88 36)
  )

;; Disable tool, menu and scroll bars.
;; The menu bar can still be accessed with =F10=.
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1)
  )
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1)
  )
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1)
  )

;; Automatically close brackets.
(setq
 electric-pair-pairs
 '(
   (?\{ . ?\})
   (?\( . ?\))
   (?\[ . ?\])
   (?\" . ?\")
   )
 )
(electric-pair-mode t)

;; Set encoding to UTF-8
(prefer-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;; Auto reloading of buffers
(global-auto-revert-mode t)

;; Highlighting of current line
(global-hl-line-mode t)

;; Highlight parens
(show-paren-mode t)

;; Buffer switching
;; in addition to C left, C right & C-x b
(global-set-key (kbd "C-<next>")  'previous-buffer)
(global-set-key (kbd "C-<prior>") 'next-buffer)

;; For my lovely Polish keyboard:
(define-key key-translation-map (kbd "←") (kbd "M-y"))

;; Frame - make/delete
(global-set-key (kbd "C-x <next>")  'delete-frame)
(global-set-key (kbd "C-x <prior>") 'make-frame)

;; Lowercase and uppercase
;; C-x C-l to convert a region to lowercase (downcase).
(put 'downcase-region 'disabled nil)
;; C-x C-u to convert a region to uppercase.
(put 'upcase-region   'disabled nil)

;; Some terminals (or connections, ie. mosh) set <end> as <select>.
;; So, if <select> is not bound - bind it to move-end-of-line.
(if (not (global-key-binding (kbd "<select>")))
    (global-set-key (kbd "<select>") 'move-end-of-line)
  )

;; Zoom with Scroll.
;; Control & Scroll Up - Increase
(global-set-key [C-mouse-4] 'text-scale-increase)
;; Control & Scroll Down - Decrease
(global-set-key [C-mouse-5] 'text-scale-decrease)

;; C-z
;; Disable suspending Emacs with C-z and bind it to undo.
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))
(global-set-key (kbd "C-z") 'undo)

(when (executable-find "lftp")
  (setq ftp-program "lftp")
  )

;; Use "tsdh-dark" theme
(when (not window-system)
  (load-theme 'tsdh-dark)
  )


(provide 'minor)



;;; minor.el ends here
