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


trap 'exit 128' INT
export PATH
set -e


QUICKLISP_HOME="${HOME}/.local/share/quicklisp"


mkdir -p "${QUICKLISP_HOME}"
cd "${QUICKLISP_HOME}"

curl -O https://beta.quicklisp.org/quicklisp.lisp
curl -O https://beta.quicklisp.org/quicklisp.lisp.asc
curl -O https://beta.quicklisp.org/release-key.txt

gpg --import release-key.txt
gpg --verify quicklisp.lisp.asc quicklisp.lisp

sbcl --load "${QUICKLISP_HOME}/quicklisp.lisp" \
     --eval '(quicklisp-quickstart:install :path "~/.local/share/quicklisp")' \
     --eval '(quit)'
