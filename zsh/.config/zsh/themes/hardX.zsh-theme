#!/usr/bin/env zsh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License


pre_git_check="\ue0a0 "

PROMPT=$'%K{black}%F{yellow} %m %(?.%F{green}\uE0B1 \u2714.%F{red}\uE0B1 \u2718) %K{blue}%F{black}\ue0b0 %~ %K{black}%k%F{blue}\ue0b0%k%f '

RPROMPT=$'%(?.%F{blue}.%F{red})$(git_check)%f'
