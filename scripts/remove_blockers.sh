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

# Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License

# Remove potential blockers that do
# not allow mydot to be stowed correctly


trap 'exit 128' INT
export PATH


pretend=0

case "${1}"
in
    -p | -pretend | --pretend )
        pretend=1
        ;;
esac


cd "$(dirname "${0}")" || exit 1

type git || exit 1
cd "$(git rev-parse --show-toplevel)" || exit 1

for dir in *
do
    [ ! -d "${dir}" ] && continue

    for file in $(git ls-files --full-name "${dir}")
    do
        hf="${HOME}$(echo "${file}" | sed "s/${dir}//")"

        echo "${dir} - ${hf}"

        if [ -f "${hf}" ]
        then
            if [ ${pretend} -gt 0 ]
            then
                echo "...... Exists"
            else
                if rm "${hf}"
                then
                    echo "...... Removed"
                else
                    echo "...... ERROR: Failed to remove"
                fi
            fi
        fi
    done
done
