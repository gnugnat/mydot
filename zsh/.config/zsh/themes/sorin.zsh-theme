#!/usr/bin/env zsh

post_git_check=" "

PROMPT=$'%F{cyan}%~ %F{white}$(git_check)%B%F{red}>%F{yellow}>%F{green}>%b%f '

RPROMPT=$'%(?..%B%F{red}%? \u2ba0 %f%b)'
