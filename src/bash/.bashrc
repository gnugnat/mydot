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

# ~/.bashrc

# shellcheck disable=1090


# Kill Switch

if [[ $- != *i* ]]
then
    # Shell is non-interactive. Be done now!
    return
fi


# Common settings

profile="${HOME}/.profile"
[ -e "${profile}" ] && . "${profile}"


# History

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

# No double entries in the shell history
HISTCONTROL="${HISTCONTROL} erasedups:ignoreboth"


# Safety

# Set root's editor to nano
if am_i_root
then
    for i in mefe nano qmacs
    do
        if command_exists "${i}"
        then
            EDITOR="${i}"
            export EDITOR
            break
        fi
    done
    unset i
fi


# Prompt theme

_dumb_PS1=$'\h -> '
_root_PS1=$'\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 1)\]\w \[$(tput sgr0)\]
\[$(tput bold)\]\[$(tput setaf 4)\]-> \[$(tput sgr0)\]'
_user_PS1=$'\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 3)\]\w \[$(tput sgr0)\]
\[$(tput bold)\]\[$(tput setaf 4)\]-> \[$(tput sgr0)\]'

case "${TERM}"
in
    "" | dumb )
        PS1="${_dumb_PS1}"
        ;;
    * )
        if am_i_root
        then
            PS1="${_root_PS1}"
        else
            PS1="${_user_PS1}"
        fi
        ;;
esac

unset _dumb_PS1 _root_PS1 _user_PS1


# Bash tweaks

# Auto-change directory
shopt -s autocd

# Append histroy
shopt -s histappend
