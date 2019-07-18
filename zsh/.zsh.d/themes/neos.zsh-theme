#!/bin/zsh

pre_git_check=" git:$branch"

PROMPT=$'%F{yellow}\u250C%F{white}%n%F{yellow}::%F{white}%m%F{yellow} %F{red}%~%F{white}`git_check`%F{yellow}
\u2514\u2500%(?.%F{white}\u00BB.%F{red}\u00BB)%f '

RPROMPT=$'%F{yellow}[%*─%W]%f'
