#!/usr/bin/env guile
!#


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

;; Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
;; Licensed under the GNU GPL v3 License


(use-modules
 (guix scripts install)
 )


(define (executable-find exe)
  "Check if a given EXEcutable exists. Return #t or #f."
  (= 0 (system (string-append "which " exe " >/dev/null 2>&1")))
  )

(define (my-install pkglist)
  "Check if packages from the PKGLIST list exist on the system.
   If a given package does not exist install it using Guix.
   PKGLIST is a list of lists where the 1st element indicates the executable
   and 2nd optional argument indicates the name of the package to be installed
   if the executable (1st element) is not found."
  (let*
      (
       (pkgexe  (car pkglist))
       (pkgname (if (= (length pkglist) 1)
                    (car pkglist)
                    (cadr pkglist)
                    )
                )
       )
    (cond
     ((executable-find pkgexe)
      (display (string-append "[INFO]: Already installed: " pkgname "\n"))
      )
     (else
      (display (string-append "[INFO]: Installing: " pkgname "\n"))
      (guix-install pkgname)
      )
     )
    )
  )


(map my-install
     '(
       ("bash")
       ("busybox")
       ("file")
       ("git")
       ("make")
       ("pip" "python-pip")
       ("stow")
       ("tput" "ncurses")
       )
     )
