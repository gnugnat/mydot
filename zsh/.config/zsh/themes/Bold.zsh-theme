#!/bin/zsh

pre_git_check="\ue0a0 "

PROMPT=$'%B%F{green}%n@%M %F{blue}%3~ %(?.%F{blue}.%F{red})%(!.#.$)%f%b '

RPROMPT=$'%B%F{white}`git_check`%f%b'
