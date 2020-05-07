#!/usr/bin/env zsh

pre_git_check=" (%F{green}"
post_git_check="%f)"

PROMPT=$'%F{cyan}%n%f@(%F{magenta}%M%f)%F{yellow}%j%f%B>%b '

RPROMPT=$'$(git_check) %~'
