;;; init --- initialization

;;; Commentary:

;; This file is part of mydot.

;; mydot is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

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

;; This is the actual config file.
;; It is omitted if it doesn't exist so emacs won't refuse to launch.
(load-user-or-current "config.org")

;; Set path to store "custom-set"
(setq custom-file (w-u-e-d "emacs-custom.el"))


;;; init.el ends here
