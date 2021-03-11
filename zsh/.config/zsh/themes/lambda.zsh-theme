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

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


zstyle ':vcs_info:git:*' formats " %F{magenta}(%f%b%F{magenta})%f"

PROMPT=$'%B%F{blue}(%f%1~${vcs_info_msg_0_}%F{blue})%(?..%F{magenta})\u03bb%f%f%b '

RPROMPT=$'%B%F{blue}(%f%W %F{magenta}(%f%*%F{magenta})%f%F{blue})%f%b'
