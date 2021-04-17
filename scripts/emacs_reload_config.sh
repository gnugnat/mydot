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


mydot_emacs_dir="$(pwd)/src/emacs/.config/emacs"

if [ -d "${mydot_emacs_dir}" ]
then
    cd "${mydot_emacs_dir}"
else
    echo "[DEBUG]: No such directory ${mydot_emacs_dir}"
    cd "${USER_EMACS_DIRECTORY:-${HOME}/.config/emacs}"
fi


if [ -f ./config.el ]
then
    rm ./config.el
elif [ -f "${USER_EMACS_DIRECTORY}"/config.el ]
then
    rm "${USER_EMACS_DIRECTORY}"/config.el
fi

sh ./load.sh --batch
