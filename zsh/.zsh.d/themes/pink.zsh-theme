#!/bin/zsh

git_check () {
    branch=$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    [ ! -z $branch ] && echo "\ue0a0 $branch"
}

PROMPT=$'%F{magenta}%M %F{blue}%5~ %(?.%F{blue}.%F{red})%#%f '

RPROMPT=$'%(?.%F{magenta}.%F{red})`git_check`%f'
