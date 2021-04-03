#!/usr/bin/env zsh


# This file is part of mydot.

# mydot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.

# mydot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with mydot.  If not, see <https://www.gnu.org/licenses/>.

# Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


alias zc >/dev/null && unalias zc
alias zcalc >/dev/null && unalias zcalc

autoload -U zcalc


ZCALCPROMPT="(ZCALC)[%1v]> "


# WORKAROUND: History hack
#             set HOME and ZDOTDIR to ZCACHEDIR while invoking zcalc
# https://github.com/zsh-users/zsh/blob/a7d5d239e6ab729515083a88cfaf955e078c1685/Functions/Misc/zcalc#L128
rbind zcalc zcalc 'HOME=${ZCACHEDIR} ZDOTDIR=${ZCACHEDIR} zcalc'


zc() {
    ( [ -n "${1}" ] && zcalc -e "${@}" ) || zcalc
}

rbind zc zc 'noglob zc'
