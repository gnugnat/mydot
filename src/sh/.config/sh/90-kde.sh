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

# This forces KDE apps launched via a terminal to inhibit the KDE theme
# instead of the one set by QT_QPA_PLATFORMTHEME, for example via qt5ct.


if [ "${XDG_CURRENT_DESKTOP}" = "KDE" ]
then
    QT_QPA_PLATFORMTHEME=""
    export QT_QPA_PLATFORMTHEME
fi
