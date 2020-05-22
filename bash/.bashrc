#!/usr/bin/env bash


#  _               _
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|
# ~/.bashrc


# >>> Kill Switch

if [[ $- != *i* ]]
then
    # Shell is non-interactive. Be done now!
    return
fi


# >>> General setup

# Source the system profile
[ -f /etc/profile ] && source /etc/profile

# Source common shell functions
shell_functions="${HOME}/.config/sh/functions"
[ -f "${shell_functions}" ] && source "${shell_functions}"


# >>> Path

setup_path


# >>> Aliases

# Source shell-agnostic aliases
source_file "${HOME}/.config/sh/aliases"


# >>> History

# File
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

# set root user editor to nano
if [ ${EUID} -eq 0 ]
then
    if command -v nano >/dev/null 2>&1
    then
        export EDITOR=nano
    fi
fi


# >>> Theme

if [ ${EUID} -eq 0 ]
then
    PS1=$'\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 1)\]\w\[$(tput setaf 4)\] \u00BB \[$(tput sgr0)\]'
else
    PS1=$'\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 3)\]\w\[$(tput setaf 4)\] \u00BB \[$(tput sgr0)\]'
fi


# >>> Miscellaneous

# Auto-change directory
shopt -s autocd

# Append histroy
shopt -s histappend

# No double entries in the shell history
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
