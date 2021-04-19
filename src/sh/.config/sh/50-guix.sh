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


_guix_profile="${HOME}/.guix-profile"

if [ -e "${_guix_profile}" ]
then
    GUIX_PROFILE="${_guix_profile}"
    export GUIX_PROFILE
    source_file "${GUIX_PROFILE}/etc/profile"
    GUIX_LOCPATH="${_guix_profile}/lib/locale"
    export GUIX_LOCPATH
fi

unset _guix_profile
