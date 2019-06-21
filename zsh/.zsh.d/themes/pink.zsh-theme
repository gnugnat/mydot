#!/bin/zsh

PROMPT=$'%F{magenta}%M %F{blue}%5~ %(?.%F{blue}.%F{red})%#%f '

RPROMPT=$'%(?.%F{magenta}.%F{red})$(__git_ps1 "\ue0a0 %s")%f'
