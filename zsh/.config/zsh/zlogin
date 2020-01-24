#!/usr/bin/env zsh


#      _             _       
#  ___| | ___   __ _(_)_ __
# |_  / |/ _ \ / _` | | '_ \ 
#  / /| | (_) | (_| | | | | |
# /___|_|\___/ \__, |_|_| |_|
#              |___/


# ZDOTDIR Warning
[ ! -d $ZDOTDIR ] && echo "!!!Warning!!! No $ZDOTDIR found!!!"

# Create ZSH cache directory
[ ! -d $ZCACHEDIR ] && mkdir -p $ZCACHEDIR

# Get the plugins if there is no plugins directory
if [ ! -e $ZDOTDIR/plugins ]; then
    echo "Download plugins? [Y/n]"
    read -r dow_ans
    case $dow_ans in
	[nN][oO]|[nN])
	    echo "Not downloading plugins"
	    mkdir $ZDOTDIR/plugins
	    ;;
	*)
	    echo "Downloading plugins..."
	    $ZDOTDIR/zsh-get-plugins.sh
	    source $ZDOTDIR/.zshrc
	    ;;
    esac
fi

# Choose a theme if it's not set
if [ ! -e $ZDOTDIR/tty.zsh-theme ] || [ ! -e $ZDOTDIR/emu.zsh-theme ]; then
    echo "Choose which ZSH themes to use"
    $ZDOTDIR/zsh-choose-theme.sh
    source $ZDOTDIR/.zshrc
fi

# Link one of greeters from
# greeters to zsh-greeter
if [ ! -e $ZDOTDIR/zsh-greeter ]; then
    echo "Choose which ZSH greeter to use"
    $ZDOTDIR/zsh-choose-greeter.sh
else
    source $ZDOTDIR/zsh-greeter
fi
