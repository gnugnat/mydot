#!/bin/sh


# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the ISC License

# This script doesn't really execute anything else
# It just formats the status-right nicely

# shellcheck disable=2016


printf_script() {
    printf "%s" "$(exec "${HOME}/.config/tmux/${1}")"
}


printf_script "tmux-battery.sh"


printf ' '
printf '#[bg=#222222,fg=#cccccc]'
printf ' '

printf_script "tmux-ram.sh"


printf ' '
printf '#[bg=#333333,fg=#bbbbbb]'
printf ' '

printf_script "tmux-thermal.sh"


printf ' '
printf '#[bg=#444444,fg=#eeeeee]'
printf ' '

printf_script "tmux-load.sh"


printf ' '
printf '#[bg=#555555,fg=#ffffff]'
printf ' '

printf "%s" "$(date +"%b %d %H:%M")"


printf ' '
