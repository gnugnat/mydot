#!/bin/sh


#      _
#  ___| |__
# / __| '_ \
# \__ \ | | |
# |___/_| |_|
# ~/.profile


# ~/.profile: executed by the command interpreter for LOGIN shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.


# >>> General setup

# Source common shell functions

shell_functions="${HOME}/.config/sh/functions"
[ -f "${shell_functions}" ] && . "${shell_functions}"


# >>> Path

setup_path


# >>> Aliases

# Source shell-agnostic aliases
source_file "${HOME}/.config/sh/aliases"


# >>> Prompt

PS1="(SH)> "
export PS1

PS2="└── "
export PS2


# >>> Editor

# If EDITOR variable is empty set the editor to nano
[ -z "$EDITOR" ] && export EDITOR=nano


# >>> Bash

# If running shell appears to be bash,
# also source the .bashrc
if [ -n "${BASH_VERSION}" ]; then
    # include .bashrc if it exists
    if [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
fi
