;;; erc-channels.el --- small tweaks that don't require packages.


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



;;; Commentary:

;; Set a list of IRC channels to automatically join.

;; Use with mydot: https://gitlab.com/xgqt/mydot



;;; Code:


(require 'erc-join)


(setq
 erc-autojoin-channels-alist
 '(
   ;; Libera - https://libera.chat/
   (".*\\.libera.chat"
    "#blastwave"
    "#gentoo"
    "#gentoo-chat"
    "#gentoo-dev"
    "#gentoo-guru"
    "#gentoo-proxy-maint"
    "#gentoo-qt"
    "#guix"
    "#kde"
    "#lisp"
    "#racket"
    "#scheme"
    "#termux"
    )
   ;; OFTC - https://www.oftc.net/
   (".*\\.oftc.net"
    "#alpine-devel"
    "#alpine-linux"
    "#gentoo"
    )
   ;; Rizon - https://rizon.net/
   (".*\\.rizon.net"
    "#cloveros"
    )
   )
 )


(provide 'erc-channels)



;;; erc-channels.el ends here
