#!/usr/bin/env zsh


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

# SC2207: Prefer mapfile or read -a to split command output
# shellcheck disable=2207


# Find and execute commands on ebuild scripts

if command_exists emerge
then
    function ebuild-exec() {
        if [ -z "${2}" ]
        then
            echo "Wrong number of arguments"
            return 1
        fi

        local ebuilds=(
            $(find "${EPREFIX}/var/db/repos" -name "*$(basename "${1}")*.ebuild")
        )

        if [ -n "${ebuilds[1]}" ]
        then
            shift
            eval "${@}" "${ebuilds[@]}"
        fi
    }

    function ebuild-edit() {
        ebuild-exec "${1}" "${EDITOR}"
    }

    function ebuild-view() {
        ebuild-exec "${1}" cat | "${PAGER}"
        #                      ^ because less...
    }
fi
