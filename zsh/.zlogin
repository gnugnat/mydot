#!/bin/zsh

#      _             _       
#  ___| | ___   __ _(_)_ __  
# |_  / |/ _ \ / _` | | '_ \ 
#  / /| | (_) | (_| | | | | |
# /___|_|\___/ \__, |_|_| |_|
#              |___/        

### MYZSHDIR Warning
if [ ! -d $MYZSHDIR ]; then echo "!!!Warning!!! No $MYZSHDIR found!!!"; fi

### Get the plugins if there is no plugins directory
if [ ! -e $MYZSHDIR/plugins ]; then
    echo "Downloading plugins..."
    $MYZSHDIR/zsh-get-plugins.sh
    source ~/.zshrc
fi

### Choose a theme if it's not set
if [[ ! -e $MYZSHDIR/tty.zsh-theme || ! -e $MYZSHDIR/emu.zsh-theme ]]; then
    echo "Link one of themes in $MYZSHDIR/themes to $MYZSHDIR/tty.zsh-theme and one to $MYZSHDIR/emu.zsh-theme"
    $MYZSHDIR/zsh-choose-theme.sh
    source ~/.zshrc
fi

### larrysay
(fortune 2>/dev/null || zsh --version) | cowsay -f $MYZSHDIR/extra/larry.cow 2>/dev/null
