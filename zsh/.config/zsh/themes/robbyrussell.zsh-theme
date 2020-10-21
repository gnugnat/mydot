#!/usr/bin/env zsh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License


pre_git_check="%F{blue} git:(%F{red}"
post_git_check="%F{blue})%f"

PROMPT=$'%B%(?.%F{green}.%F{red})\u279c %F{cyan}%1~$(git_check)%(?..%F{yellow} \u2718)%f%b '
