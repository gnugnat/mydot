#!/bin/zsh

git_check () {
    branch=$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    [ ! -z $branch ] && echo "\ue0a0 $branch"
}

PROMPT=$'%B%F{green}%n@%M %F{blue}%3~ %(?.%F{blue}.%F{red})%(!.#.$)%f%b '

RPROMPT=$'%B%F{white}`git_check`%f%b'
