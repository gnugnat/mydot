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

# Big Gentoo Filesystem
# powerline-like theme that displays
# a location icon

# Best font compability:
# https://github.com/ryanoasis/nerd-fonts


# override colors
_pink="#ad7fa8"
_purple="#75507b"
_black="#000000"
_yellow="#eead0e"
_white="#ffffff"


_dir_icon () {
    case "$(pwd)"
    in
        "/")                printf "\uf0a0" ;;
        "$HOME")            printf "\uf015" ;;
        "$HOME/Desktop")    printf "\uf108" ;;
        "$HOME/Documents")  printf "\uf02d" ;;
        "$HOME/Downloads")  printf "\uf019" ;;
        "$HOME/Music")      printf "\uf001" ;;
        "$HOME/Pictures")   printf "\uf03e" ;;
        "$HOME/Public")     printf "\uf0c0" ;;
        "$HOME/Templates")  printf "\uf24d" ;;
        "$HOME/Videos")     printf "\uf03d" ;;
        *)                  printf "\uf064" ;;
    esac
}


zstyle ':vcs_info:git:*' formats "$(print -n '\uf126') %b"

PROMPT=$'%(?.%K{$_pink}.%K{$_yellow})%F{$_black} \uf30d %K{$_purple}%(?.%F{$_pink}.%F{$_yellow})\ue0b0%F{$_black} $(_dir_icon) %~ ${vcs_info_msg_0_}%K{black}%k%F{$purple}\ue0b0
%F{$white}\u25b6%k%f '
