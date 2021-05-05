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

;; Directory Local Variables
;; For more information see (info "(emacs) Directory Variables")


(
 (nil
  . (
     (locale-coding-system . 'utf-8)
     (projectile-project-compilation-cmd . "make clean dependencies docs")
     (projectile-project-test-cmd . "make test")
     )
  )
 (find-file
  . (
     (indent-tabs-mode . nil)
     (show-trailing-whitespace . t)
     (tab-width . 4)
     )
  )
 (makefile-mode
  . (
     (indent-tabs-mode . t)
     )
  )
 (yaml-mode
  . (
     (tab-width . 2)
     )
  )
 )
