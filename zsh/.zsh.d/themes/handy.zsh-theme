#!/bin/zsh

PROMPT=$'%(?.%F{blue}.%F{red})\u261b%f '

RPROMPT=$'%F{cyan}%1~$(__git_ps1 " (%s)") %F{green}%n %F{yellow}%M%f'