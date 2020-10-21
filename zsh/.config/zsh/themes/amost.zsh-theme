#!/usr/bin/env zsh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License


pre_git_check=" %f("
post_git_check=")%f"

PROMPT=$'%B%F{yellow}%M %F{cyan}%n %F{blue}%~$(git_check) %f
%F{green}%(?..%F{red})> %f%b'

RPROMPT=$'%F{cyan}%* %W%f%b'
