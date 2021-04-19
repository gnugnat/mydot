;;; init --- initialization

;;; Commentary:

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

;;  delete ~/.emacs and ~/.emacs.d
;;  place this file in
;;  ~/.config/emacs directory

;;; Code:


;;; Fix garbage collection (makes Emacs start up faster)

(defvar startup/gc-cons-threshold gc-cons-threshold)

(setq
 gc-cons-threshold most-positive-fixnum
 gc-cons-percentage 0.6
 )

(defun startup/reset-gc ()
  "Revert to default garbage collector settings."
  (setq
   gc-cons-threshold startup/gc-cons-threshold
   gc-cons-percentage 0.1
   )
  )

(add-hook 'emacs-startup-hook 'startup/reset-gc)


;;; Fix the file name handler

(defvar startup/file-name-handler-alist file-name-handler-alist)

(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  "Revert to default `file-name-handler-alist'."
  (setq file-name-handler-alist startup/file-name-handler-alist)
  )

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)


;;; Packages

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


;;; Functions for loading components

(defun load-org-file (file)
  "Load a org FILE into the running Emacs."
  (org-babel-load-file (expand-file-name file))
  )

(defun with-user-emacs-directory (file)
  "Return a path to FILE prepended with 'user-emacs-directory'."
  (concat user-emacs-directory file)
  )
(defalias 'w-u-e-d 'with-user-emacs-directory)

(defun load-user-or-current (file)
  "Load FILE that is found in 'user-emacs-directory' or current directory."
  (if (file-readable-p (w-u-e-d file))
      (load-org-file (w-u-e-d file))
    (if (file-readable-p file)
      (load-org-file file)
      )
    )
  )


;;; Load other custom components

;; Load site-lisp from GUIX_PROFILE
(let*
    (
     (guix-profile   (getenv "GUIX_PROFILE"))
     (guix-site-lisp (concat guix-profile "/share/emacs/site-lisp"))
     )
  ;; If we check only if "file exists" we would load stuff from / (system root)
  ;; if it is found there (believe me those bug happen).
  ;; So, check if "guix-profile" is null and then check
  ;; if "${GUIX_PROFILE}/share/emacs/site-lisp" exists.
  (when guix-profile
    (when (file-exists-p guix-site-lisp)
      (add-to-list 'load-path guix-site-lisp)
      )
    )
  )

;; Custom site-lisp
(add-to-list 'load-path (w-u-e-d "assets/site-lisp"))

;; Set path to store "custom-set"
(setq custom-file (w-u-e-d "emacs-custom.el"))

;; This is the actual config file.
;; It is omitted if it doesn't exist so emacs won't refuse to launch.
(defun config-load ()
  "Load config.org."
  (load-user-or-current "config.org")
  )

;; Now let's load it.
(config-load)


;;; init.el ends here
