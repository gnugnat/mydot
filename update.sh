#!/bin/sh


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

# "Aggresively" update mydot


trap 'exit 128' INT
export PATH
set -e


# First check if we have net
# so ping the main mydot hosting
if ! ping -c 1 gitlab.com >/dev/null 2>&1
then
    echo "ERROR: Seems like we can not connect to the Internet"
    exit 1
fi

# Go to mydot source
cd "$(dirname "$(realpath "${0}")")"

make update-mydot

echo ">>> mydot updated"
