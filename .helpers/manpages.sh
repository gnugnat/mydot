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


trap 'exit 128' INT
export PATH


cd "$(dirname "$(realpath "${0}")")" || exit 1
cd "$(git rev-parse --show-toplevel)" || exit 1


top_dir="$(pwd)"
doc_dir="${top_dir}/.docs"


[ -d "${doc_dir}" ] && rm -r "${doc_dir}"
mkdir -p "${doc_dir}"


# Generate MANpages from scripts using help2man

cd "${top_dir}/scripts/.local/share/bin" || exit 1

for i in *
do
    help2man "${i}" \
             --locale="en_US.utf8" \
             --no-discard-stderr \
             --no-info \
             --output="${doc_dir}/${i}.1"
done


# Generate PDFs from MANpages

cd "${doc_dir}" || exit 1

for i in *
do
    pandoc "${i}" -o "$(echo "${i}" | sed 's/.1//g').pdf"
done
