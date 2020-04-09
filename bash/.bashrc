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

# Source common shell functions

shell_functions="${HOME}/.config/sh/functions"
[ -f "${shell_functions}" ] && source "${shell_functions}"


# >>> Path

setup_path


# >>> Aliases

# Source shell-agnostic aliases
source_file "${HOME}/.config/sh/aliases"


# >>> History

# Size
HISTSIZE=50000
HISTFILESIZE=50000


# >>> Theme

PS1=$'\[$(tput bold)\]\[$(tput setaf 3)\]\w\[$(tput setaf 4)\] \u00BB \[$(tput sgr0)\]'


# >>> Miscellaneous

# Auto-change directory
shopt -s autocd

# Append histroy
shopt -s histappend

# No double entries in the shell history
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
