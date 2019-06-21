#!/bin/zsh

PROMPT=$'%B%F{green}%n@%M %F{blue}%3~ %(?.%F{blue}.%F{red})%(!.#.$)%f%b '

RPROMPT=$'%B%F{white}$(__git_ps1 "\ue0a0 %s")%f%b'
