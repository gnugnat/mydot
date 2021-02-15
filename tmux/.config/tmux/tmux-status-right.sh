#!/bin/sh


# Copyright (c) 2020-2021, Maciej Barć <xgqt@protonmail.com>
# Licensed under the ISC License

# This script doesn't really execute anything else
# It just formats the status-right nicely

# shellcheck disable=2016


printf "%s" '#(${HOME}/.config/tmux/tmux-battery.sh)'

printf "%s" ' '
printf "%s" '#[bg=#222222,fg=#cccccc]'
printf "%s" ' '

printf "%s" '#(${HOME}/.config/tmux/tmux-ram.sh)'

printf "%s" ' '
printf "%s" '#[bg=#333333,fg=#bbbbbb]'
printf "%s" ' '

printf "%s" '#(${HOME}/.config/tmux/tmux-thermal.sh)'

printf "%s" ' '
printf "%s" '#[bg=#444444,fg=#eeeeee]'
printf "%s" ' '

printf "%s" '#(${HOME}/.config/tmux/tmux-load.sh)'

printf "%s" ' '
printf "%s" '#[bg=#555555,fg=#ffffff]'
printf "%s" ' '

printf "%s" '#(date +"%b %d %H:%M")'

printf "%s" ' '
