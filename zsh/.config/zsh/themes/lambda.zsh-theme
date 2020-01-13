#!/usr/bin/env zsh

pre_git_check=" %F{magenta}(%f"
post_git_check="%F{magenta})%f"

PROMPT=$'%B%F{blue}(%f%1~$(git_check)%F{blue})%(?..%F{magenta})\u03bb%f%f%b '

RPROMPT=$'%B%F{blue}(%f%W %F{magenta}(%f%*%F{magenta})%f%F{blue})%f%b'
