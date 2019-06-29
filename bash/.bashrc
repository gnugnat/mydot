#!/bin/bash

# ~/.bashrc

#  _               _              
# | |__   __ _ ___| |__  _ __ ___ 
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__ 
# |_.__/ \__,_|___/_| |_|_|  \___|

### Kill Switch ###
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

### Scripts ###
export PATH=$PATH:$HOME/scripts

### User Settings ###
# text editor
export EDITOR=nano

### Prompt ###
PS1=$'\[$(tput bold)\]\[$(tput setaf 3)\] \w\[$(tput setaf 4)\] \u00BB \[$(tput sgr0)\]'

### History ###
HISTSIZE=3000
HISTFILESIZE=3000
# no double entries in the shell history
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
# append histroy
shopt -s histappend

### Aliases ###
if [[ -e $HOME/.zsh.d/aliases ]]; then
    . $HOME/.zsh.d/aliases
fi

### Misc ###
# auto-change directory
shopt -s autocd
