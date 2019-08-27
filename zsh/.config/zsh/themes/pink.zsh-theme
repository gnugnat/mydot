#!/usr/bin/env zsh

pre_git_check="\ue0a0 "

PROMPT=$'%F{magenta}%M %F{blue}%5~ %(?.%F{blue}.%F{red})%#%f '

RPROMPT=$'%(?.%F{magenta}.%F{red})`git_check`%f'
