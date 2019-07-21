#!/bin/sh

# Get the required zsh plugins

# set ZDOTDIR if it is not set
ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# make plugins directory
mkdir "$ZDOTDIR/plugins"

git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZDOTDIR/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions $ZDOTDIR/plugins/zsh-autosuggestions
