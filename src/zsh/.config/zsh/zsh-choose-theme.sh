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

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


if [ -z "${ZDOTDIR}" ]; then echo "No ZDOTDIR set, exiting..."; exit 1 ; fi


( cd "${ZDOTDIR}/themes" && ls ) | nl

printf "Choose a tty theme ... "
read -r _tty_zsh_theme
printf "Choose a emulator theme ... "
read -r _emu_zsh_tmeme

ln -sf "$(echo "${ZDOTDIR}/themes"/* | cut -d" " -f"${_tty_zsh_theme}")" "${ZDOTDIR}/tty.zsh-theme"
ln -sf "$(echo "${ZDOTDIR}/themes"/* | cut -d" " -f"${_emu_zsh_tmeme}")" "${ZDOTDIR}/emu.zsh-theme"

unset _tty_zsh_theme
unset _emu_zsh_tmeme
