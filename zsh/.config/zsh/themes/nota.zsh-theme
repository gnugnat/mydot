#!/usr/bin/env zsh

# %3~
# %(?.%F{green}\u25CF.%F{red}\u25CF)

PROMPT=$'%F{cyan}%m%(?.%F{green}\u25CF.%F{red}\u25CF)%F{blue}%1~%F{white}\u00BB%f '

RPROMPT=$'%F{white}[%*]%f'
