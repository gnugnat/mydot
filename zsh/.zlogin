#!/bin/zsh

#      _             _       
#  ___| | ___   __ _(_)_ __  
# |_  / |/ _ \ / _` | | '_ \ 
#  / /| | (_) | (_| | | | | |
# /___|_|\___/ \__, |_|_| |_|
#              |___/        

### MYZSHDIR Warning ###
if [ ! -d $MYZSHDIR ]; then echo "!!!Warning!!! No $MYZSHDIR found!!!"; fi

### Warning message if a theme isn't set ###
if [[ ! -e $MYZSHDIR/tty.zsh-theme || ! -e $MYZSHDIR/emu.zsh-theme ]]; then
    echo "Link one of themes in $MYZSHDIR/themes to $MYZSHDIR/tty.zsh-theme and one to $MYZSHDIR/emu.zsh-theme"
# run script to choose a theme
    $MYZSHDIR/choose-theme.sh
    source ~/.zshrc
fi

### larrysay ###
(fortune 2>/dev/null || zsh --version) | cowsay -f $MYZSHDIR/extra/larry.cow 2>/dev/null
fortune -v 2>/dev/null 1>/dev/null && zsh --version
