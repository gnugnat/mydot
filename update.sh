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


trap 'exit 128' INT
export PATH
set -e


prog_name="$(basename "${0}")"
prog_desc="aggressively update mydot"
prog_args=""


usage() {
    cat <<EOF
Usage: ${prog_name} [OPTION]... ${prog_args}
${prog_name} - ${prog_desc}

Options:
    -V, --version  show program version
    -h, --help     show avalible options
EOF
}

version() {
    cat <<EOF
${prog_name} 9999

Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
Licensed under the GNU GPL v3 License
EOF
}


case "${1}"
in
    -h | -help | --help )
        usage
        exit 0
        ;;
    -V | -version | --version )
        version
        exit 0
        ;;
    -* )
        version
        echo
        usage
        exit 1
        ;;
esac


# First check if we have net
# so ping the main mydot hosting
if ! ping -c 1 gitlab.com >/dev/null 2>&1
then
    echo "ERROR: Seems like we can not connect to the Internet"
    exit 1
fi

# Go to mydot root
cd "$(dirname "$(realpath "${0}")")"

make update-mydot

echo ">>> mydot updated"
