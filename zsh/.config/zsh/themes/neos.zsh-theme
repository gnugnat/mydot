#!/usr/bin/env zsh


# This file is part of mydot.

# mydot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# mydot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with mydot.  If not, see <https://www.gnu.org/licenses/>.

# Copyright (c) 2020-2021, Maciej Barć <xgqt@protonmail.com>
# Licensed under the GNU GPL v3 License


zstyle ':vcs_info:git:*' formats ' git:%b'

PROMPT=$'%F{yellow}\u250C%F{white}%n%F{yellow}::%F{white}%m%F{yellow} %F{red}%~%F{white}${vcs_info_msg_0_}%F{yellow}
\u2514\u2500%(?.%F{white}\u00BB.%F{red}\u00BB)%f '

RPROMPT=$'%F{yellow}[%*─%W]%f'
