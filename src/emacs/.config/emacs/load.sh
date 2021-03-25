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

# Load init.el from this script's directory


trap 'exit 128' INT
export PATH
set -e


cd "$(dirname "${0}")"

mkdir -p ~/.config/emacs
mkdir -p ~/Documents
touch ~/Documents/todo.org

[ -n "${1}" ] && echo "Additional options: ${*}"
emacs "${@}" --no-init --load ./init.el
