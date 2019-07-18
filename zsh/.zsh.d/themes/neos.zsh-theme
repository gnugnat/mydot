#!/bin/zsh

git_check () {
    branch=$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    [ ! -z $branch ] && echo " git:$branch"
}

PROMPT=$'%F{yellow}\u250C%F{white}%n%F{yellow}::%F{white}%m%F{yellow} %F{red}%~%F{white}`git_check`%F{yellow}
\u2514\u2500%(?.%F{white}\u00BB.%F{red}\u00BB)%f '

RPROMPT=$'%F{yellow}[%*─%W]%f'
