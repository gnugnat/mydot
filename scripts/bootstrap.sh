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

# Execute this with:
# curl https://gitlab.com/xgqt/mydot/-/raw/master/bootstrap.sh | bash
# ... assuming 'gitlab.com' is this repo's remote of course ;)
# ... you can also export CLONETO to clone mydot into a different location


trap 'exit 128' INT
export PATH
set -e


CLONETO="${CLONETO:-${HOME}/source/public/gitlab.com/xgqt}"


mkdir -p "${CLONETO}"
cd "${CLONETO}"

git clone --recursive --verbose "https://gitlab.com/xgqt/mydot"
cd ./mydot
make install
