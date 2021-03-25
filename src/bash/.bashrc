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

#  _               _
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|
# ~/.bashrc

# shellcheck disable=1090


# >>> Kill Switch

if [[ $- != *i* ]]
then
    # Shell is non-interactive. Be done now!
    return
fi


# >>> Common settings

profile="${HOME}/.profile"
[ -e "${profile}" ] && . "${profile}"


# >>> History

# File location
if [ -n "${XDG_CACHE_HOME}" ]
then
    mkdir -p "${XDG_CACHE_HOME}"/bash
    export HISTFILE="${XDG_CACHE_HOME}"/bash/history
else
    mkdir -p "${HOME}"/.cache/bash
    export HISTFILE="${HOME}"/.cache/bash/history
fi

# Size
HISTSIZE=50000
HISTFILESIZE=50000


# >>> Safety

# Set root's editor to nano
if [ ${EUID} -eq 0 ]
then
    if command -v qmacs >/dev/null 2>&1
    then
        export EDITOR=qmacs
    elif command -v nano >/dev/null 2>&1
    then
        export EDITOR=nano
    fi
fi


# >>> Prompt theme

if [ ${EUID} -eq 0 ]
then
    PS1=$'\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 1)\]\w\[$(tput setaf 4)\] \u00BB \[$(tput sgr0)\]'
else
    PS1=$'\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 3)\]\w\[$(tput setaf 4)\] \u00BB \[$(tput sgr0)\]'
fi


# >>> Bash tweaks

# Auto-change directory
shopt -s autocd

# Append histroy
shopt -s histappend

# No double entries in the shell history
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
