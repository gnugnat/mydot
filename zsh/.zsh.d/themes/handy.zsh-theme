#!/bin/zsh

git_check () {
    branch=$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    [ ! -z $branch ] && echo "%F{cyan} (%F{blue}$branch%F{cyan})%f"
}

PROMPT=$'%(?.%F{blue}.%F{red})\u261b%f '

RPROMPT=$'%F{cyan}%1~`git_check` %F{green}%n %F{yellow}%M%f'
