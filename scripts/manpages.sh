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


cd "$(dirname "${0}")" || exit 1

type git || exit 1
cd "$(git rev-parse --show-toplevel)" || exit 1


top_dir="$(pwd)"
doc_dir="${top_dir}/docs"

doc_html="${doc_dir}/html"
doc_man="${doc_dir}/man/man1"
doc_pdf="${doc_dir}/pdf"


mkdir -p "${doc_html}"
mkdir -p "${doc_man}"
mkdir -p "${doc_pdf}"


# Generate MANpages from scripts using help2man

cd "${top_dir}/src/scripts/.local/share/bin" || exit 1

for i in *
do
    output="${doc_man}/${i}.1"

    echo "[DEBUG]: i         = ${i}"
    echo "[DEBUG]: output    = ${output}"

    help2man "${i}" \
             --locale="en_US.utf8" \
             --no-discard-stderr \
             --no-info \
             --output="${output}"
done


# Generate PDFs from MANpages

cd "${doc_man}" || exit 1

for i in *.1
do
    nice_name="$(echo "${i}" | sed 's/.1//g')"

    echo "[DEBUG]: i         = ${i}"
    echo "[DEBUG]: nice_name = ${nice_name}"

    pandoc "${i}" -o "${doc_html}/${nice_name}.html"
    pandoc "${i}" -o "${doc_pdf}/${nice_name}.pdf"
done
