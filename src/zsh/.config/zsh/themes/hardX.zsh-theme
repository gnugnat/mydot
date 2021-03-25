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

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


zstyle ':vcs_info:git:*' formats "$(print -n '\uf126') %b"

PROMPT=$'%K{black}%F{yellow} %m %(?.%F{green}\uE0B1 \u2714.%F{red}\uE0B1 \u2718) %K{blue}%F{black}\ue0b0 %~ %K{black}%k%F{blue}\ue0b0%k%f '

RPROMPT=$'%(?.%F{blue}.%F{red})${vcs_info_msg_0_}%f'
