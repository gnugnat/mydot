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


cd "$(dirname "${0}")" || exit 1

type git || exit 1
cd "$(git rev-parse --show-toplevel)" || exit 1


cd ./src/neovim/.config/nvim || exit 1

for d in autoload plugged
do
    [ -e "${d}" ] && rm -fr "${d}" && echo "Removed ${d}"
done


exit 0
