#!/bin/zsh

#      _             _       
#  ___| | ___   __ _(_)_ __  
# |_  / |/ _ \ / _` | | '_ \ 
#  / /| | (_) | (_| | | | | |
# /___|_|\___/ \__, |_|_| |_|
#              |___/        

### MYZSHDIR Warning
#
if [ ! -d $MYZSHDIR ]; then echo "!!!Warning!!! No $MYZSHDIR found!!!"; fi

### Plugins
#
# Get the plugins if there is no plugins directory
if [ ! -e $MYZSHDIR/plugins ]; then
    echo "Downloading plugins..."
    $MYZSHDIR/zsh-get-plugins.sh
    source ~/.zshrc
fi

### Theme
#
# Choose a theme if it's not set
if [[ ! -e $MYZSHDIR/tty.zsh-theme || ! -e $MYZSHDIR/emu.zsh-theme ]]; then
    echo "Link one of themes in $MYZSHDIR/themes to $MYZSHDIR/tty.zsh-theme and one to $MYZSHDIR/emu.zsh-theme"
    $MYZSHDIR/zsh-choose-theme.sh
    source ~/.zshrc
fi

### Greeter
#
# Link one of greeters from
# greeters to zsh-greeter
if [ ! -e $MYZSHDIR/zsh-greeter ]; then
    echo "Choose which ZSH greeter to use"
    $MYZSHDIR/zsh-choose-greeter.sh
else
    source $MYZSHDIR/zsh-greeter
fi
