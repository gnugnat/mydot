#!/usr/bin/env zsh


#          _
#  _______| |__   ___ _ ____   __
# |_  / __| '_ \ / _ \ '_ \ \ / /
#  / /\__ \ | | |  __/ | | \ V /
# /___|___/_| |_|\___|_| |_|\_/


# Set where the rest of ZSH files are located
export ZDOTDIR="${HOME}/.config/zsh"

# Set where ZSH cache is stored
export ZCACHEDIR="${HOME}/.cache/zsh"

# Auto-set the editor
if command -v emacs >/dev/null 2>&1
then
    if pgrep -f 'emacs --daemon'
    then
        EDITOR=emacsclient
    else
        EDITOR=emacs
    fi
elif command -v vim >/dev/null 2>&1
then
    EDITOR=vim
else
    EDITOR=nano
fi
export EDITOR
