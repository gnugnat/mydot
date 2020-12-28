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

# Copyright (c) 2020, XGQT
# Licensed under the GNU GPL v3 License

# Big Gentoo Filesystem
# powerline-like theme that displays
# a location icon

# Best font compability:
# https://github.com/ryanoasis/nerd-fonts

# override colors
pink="#ad7fa8"
purple="#75507b"
black="#000000"
yellow="#eead0e"
white="#ffffff"

dir_icon () {
    di=$(pwd)
    case $di in
        "/")			printf "\uf0a0" ;;
        "$HOME")		printf "\uf015" ;;
        "$HOME/Desktop")	printf "\uf108" ;;
        "$HOME/Documents")	printf "\uf02d" ;;
        "$HOME/Downloads")	printf "\uf019" ;;
        "$HOME/Music")		printf "\uf001" ;;
        "$HOME/Pictures")	printf "\uf03e" ;;
        "$HOME/Public")		printf "\uf0c0" ;;
        "$HOME/Templates")	printf "\uf24d" ;;
        "$HOME/Videos")		printf "\uf03d" ;;
        *)			printf "\uf064" ;;
    esac
}

pre_git_check="\uf126 "

PROMPT=$'%(?.%K{$pink}.%K{$yellow})%F{$black} \uf30d %K{$purple}%(?.%F{$pink}.%F{$yellow})\ue0b0%F{$black} $(dir_icon) %~ $(git_check)%K{black}%k%F{$purple}\ue0b0
%F{$white}\u25b6%k%f '
