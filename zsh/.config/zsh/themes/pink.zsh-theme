#!/usr/bin/env zsh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License


pre_git_check="\ue0a0 "

PROMPT=$'%F{magenta}%M %F{blue}%5~ %(?.%F{blue}.%F{red})%#%f '

RPROMPT=$'%(?.%F{magenta}.%F{red})$(git_check)%f'
