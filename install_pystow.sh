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

# Copyright (c) 2021, Maciej Barć <xgqt@protonmail.com>
# Licensed under the GNU GPL v3 License


trap 'exit 128' INT
export PATH
set -e


for c in git make mktemp python3
do
    if ! command -v "${c}"
    then
        echo "ERROR: No ${c} found"
        exit 1
    fi
done


cd "$(mktemp -d)"

git clone --verbose --recursive https://gitlab.com/xgqt/pystow
cd ./pystow

make install
