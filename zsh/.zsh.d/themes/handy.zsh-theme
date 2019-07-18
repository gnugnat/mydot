#!/bin/zsh

pre_git_check="%F{cyan} (%F{blue}"
post_git_check="%F{cyan})%f"

PROMPT=$'%(?.%F{blue}.%F{red})\u261b%f '

RPROMPT=$'%F{cyan}%1~`git_check` %F{green}%n %F{yellow}%M%f'
