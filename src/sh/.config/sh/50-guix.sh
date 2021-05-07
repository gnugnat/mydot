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

# For GNU Guix


# Yes, it is supposed to source those files in this order
#   ~/.guix-profile  and then  ~/.config/guix/current

for _d in "${HOME}/.guix-profile" "${HOME}/.config/guix/current"
do
    _guix_profile="${_d}"

    if [ -e "${_guix_profile}/etc/profile" ]
    then
        GUIX_PROFILE="${_guix_profile}"
        export GUIX_PROFILE

        source_file "${GUIX_PROFILE}/etc/profile"

        if [ -e "${_guix_profile}/lib/locale" ]
        then
            GUIX_LOCPATH="${_guix_profile}/lib/locale"
            export GUIX_LOCPATH
        fi

        hash guix
    fi
done

unset _d
unset _guix_profile
