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


zstyle ':vcs_info:git:*' formats '%F{blue} git:(%F{red}%b%F{blue})%f'

PROMPT=$'%B%(?.%F{green}.%F{red})\u279c %F{cyan}%1~${vcs_info_msg_0_}%(?..%F{yellow} \u2718)%f%b '
