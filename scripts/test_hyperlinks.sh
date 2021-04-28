#!/usr/bin/env bash


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


tempdir="$(mktemp -d)"
linksfile="${tempdir}/links.html"

mapfile -t files < <(find ./docs/html -name "*.html")


echo "[DEBUG]: ${tempdir}"
echo "[DEBUG]: ${linksfile}"


touch "${linksfile}"

for file in "${files[@]}"
do
    [ -f "${file}" ] && grep 'http.*://' "${file}" >> "${linksfile}"
done


linkchecker --ignore-url='^mailto:' --ignore-url='^file:'  \
            --check-extern "${linksfile}"  || exit 1

rm -r "${tempdir}"
