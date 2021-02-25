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

# Copyright (c) 2021, Maciej Barć <xgqt@protonmail.com>
# Licensed under the GNU GPL v3 License

# shellcheck disable=2044


trap 'exit 128' INT
export PATH


cd "$(dirname "$(realpath "${0}")")" || exit 1
cd "$(git rev-parse --show-toplevel)" || exit 1


top_dir="$(pwd)"
doc_dir="${top_dir}/.docs"


mkdir -p "${doc_dir}"


for i in $(find . -name "*.org")
do
    file_dir="$(dirname "${i}")"
    file_name="$(basename "${i}")"
    nice_name=$(echo "${i}" | sed -e 's|\.org||g' -e 's|\./||g' -e 's|/|_|g')

    echo "[DEBUG]: file_dir  = ${file_dir}"
    echo "[DEBUG]: file_name = ${file_name}"
    echo "[DEBUG]: nice_name = ${nice_name}"

    cd "${file_dir}" >/dev/null || continue

    pandoc "${file_name}" -o "${doc_dir}/${nice_name}.pdf"
    pandoc "${file_name}" -o "${doc_dir}/${nice_name}.html"

    cd - >/dev/null || exit 1
done
