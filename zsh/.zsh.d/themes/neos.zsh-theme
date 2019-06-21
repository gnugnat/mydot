#!/bin/zsh

PROMPT=$'%F{yellow}\u250C%F{white}%n%F{yellow}::%F{white}%m%F{yellow} %F{red}%~%F{white}$(__git_ps1 " git:%s")%F{yellow}
\u2514\u2500%(?.%F{white}\u00BB.%F{red}\u00BB)%f '

RPROMPT=$'%F{yellow}[%*─%W]%f'
