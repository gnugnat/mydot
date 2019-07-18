#!/bin/zsh

git_check () {
    branch=$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    [ ! -z $branch ] && echo "\ue0a0 $branch"
}

PROMPT=$'%K{black}%F{yellow} %m %(?.%F{green}\uE0B1 \u2714.%F{red}\uE0B1 \u2718) %K{blue}%F{black}\ue0b0 %~ %K{black}%k%F{blue}\ue0b0%k%f '

RPROMPT=$'%(?.%F{blue}.%F{red})`git_check`%f'
