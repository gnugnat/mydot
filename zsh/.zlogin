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

### Greeter on login
#
# You may want to link one of
# greeters in .zsh.d/greeters
# to zsh-greeter in .zsh.d
# Use zsh-choose-greeter.sh for this
source $MYZSHDIR/zsh-greeter 2>/dev/null
