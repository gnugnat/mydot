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


emacs_dir="${USER_EMACS_DIRECTORY:-${HOME}/.config/emacs}"

backup="emacs_$(date +%Y-%m-%d_%H:%M:%S)"

bak_dir="${HOME}/.cache/emacs_backup"
bak_loc="${bak_dir}/${backup}"


mkdir -p "${bak_dir}"

tar cfvz "${bak_loc}.tar.gz" "${emacs_dir}"
