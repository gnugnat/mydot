#!/bin/zsh

git_check () {
    branch=$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    [ ! -z $branch ] && echo "%F{blue} git:(%F{red}$branch%F{blue})%f"
}

PROMPT=$'%B%F{red}\u279c %F{cyan}%1~`git_check`%(?..%F{yellow} \u2718)%f%b '
