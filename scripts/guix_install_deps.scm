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
  (if (= 0
         (system (string-append "which " exe " >/dev/null 2>&1"))
         )
      #t
      #f
      )
  )

(define (my-install pkglist)
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
