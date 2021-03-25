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

# Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


trap 'exit 128' INT
export PATH
set -e


command_exists() {
    if command -v "${1}" >/dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}


for i in make mktemp python3
do
    if ! command_exists "${i}"
    then
        echo "ERROR: No ${i} found"
        exit 1
    fi
done


cd "$(mktemp -d)"


if command_exists git
then
    git clone --verbose --recursive "https://gitlab.com/xgqt/pystow"
elif command_exists wget
then
    wget "https://gitlab.com/xgqt/pystow/-/archive/master/pystow-master.tar.gz"
    tar fx ./*.tar.gz
    mv ./pystow-master ./pystow
else
    echo "ERROR: No git and/or wget found"
    exit 1
fi

cd ./pystow
make install
