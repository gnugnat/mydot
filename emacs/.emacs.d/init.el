;;; init --- initialization
;;; Commentary:
;;
;;  Copyright (c) 2020, XGQT
;;  Licensed under the ISC License
;;
;;  delete ~/.emacs file
;;  place this file in
;;  ~/.emacs.d directory

;;; Code:


;; Fix garbage collection (makes Emacs start up faster)

(setq
 gc-cons-threshold 402653184
 gc-cons-percentage 0.6
 )

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist)
  )

(defun startup/reset-gc ()
  (setq
   gc-cons-threshold 16777216
   gc-cons-percentage 0.1
   )
  )

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)


;; Packages

;; package archives
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(
        ("elpa"  . "https://tromey.com/elpa/")
        ("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("org"   . "https://orgmode.org/elpa/")
        )
      )
(package-initialize)

;; install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  )


;; Load other custom components

;; This is the actual config file. It is omitted if it doesn't exist so emacs won't refuse to launch.
(when (file-readable-p "~/.emacs.d/config.org")
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))
  )

;; Set path to store "custom-set"
(setq custom-file "~/.emacs.d/emacs-custom.el")

;;; init.el ends here
