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

# shellcheck disable=2044


trap 'exit 128' INT
export PATH


cd "$(dirname "${0}")" || exit 1

type git || exit 1
cd "$(git rev-parse --show-toplevel)" || exit 1


top_dir="$(pwd)"
doc_dir="${top_dir}/docs"

doc_html="${doc_dir}/html"
doc_pdf="${doc_dir}/pdf"


mkdir -p "${doc_html}"
mkdir -p "${doc_pdf}"


for i in $(find . -name "*.org")
do
    file_dir="$(dirname "${i}")"
    file_name="$(basename "${i}")"
    nice_name=$(echo "${i}" | sed -e 's|\.org||g' -e 's|\./||g' -e 's|\.||g' -e 's|/|_|g')

    echo "[DEBUG]: file_dir  = ${file_dir}"
    echo "[DEBUG]: file_name = ${file_name}"
    echo "[DEBUG]: nice_name = ${nice_name}"

    # We change directory, so pandoc can include all assets in the generated PDF
    cd "${file_dir}" >/dev/null || continue

    pandoc "${file_name}" -o "${doc_html}/${nice_name}.html"
    pandoc "${file_name}" -o "${doc_pdf}/${nice_name}.pdf"

    cd - >/dev/null || exit 1
done
