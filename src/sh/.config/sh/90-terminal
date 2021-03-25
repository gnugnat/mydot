#!/bin/sh


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

# This file is meant to be sourced by ~/.profile from mydot

# shellcheck disable=2016


if [ -z "${TERMINAL}" ]
then
    for _t in \
        alacritty \
        aterm \
        gnome-terminal \
        kitty \
        konsole \
        mate-terminal \
        roxterm \
        sakura \
        st \
        terminator \
        terminology \
        tilix \
        urxvt \
        xfce4-terminal \
        xst \
        xterm
    do
        if command_exists "${_t}"
        then
            TERMINAL="${_t}"
            break
        fi
    done
    unset _t
fi

a_k_a terminal '${TERMINAL}'
