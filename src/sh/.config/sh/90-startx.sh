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

# This file is meant to be sourced by ~/.profile from mydot

# Autostart X11 if it is available

# If you enable autologin on getty this can replace a Display Manager
# c1:12345:respawn:/sbin/agetty --autologin <user> --noclear 38400 tty1 linux


if ! am_i_root \
        && [ ! "${DISPLAY}" ] \
        && [ "$(tty)" = "/dev/tty1" ] \
        && command_exists startx
then
    startx "${XINITRC}" -- "${XSERVERRC}" || echo "Failed to start the default X session"
fi
