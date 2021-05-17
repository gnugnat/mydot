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


if command_exists rlwrap
then
    if nullwrap mkdir -p "${HOME}/.cache/rlwrap"
    then
        RLWRAP_HOME="${HOME}/.cache/rlwrap"
        export RLWRAP_HOME
    fi

    _opts="--ansi-colour-aware --case-insensitive --complete-filenames --prompt-colour=cyan"

    a_k_a W "rlwrap ${_opts}"

    unset _opts
fi
