#!/usr/bin/env zsh

if [ -z $ZDOTDIR ]; then echo "No ZDOTDIR set, exiting..."; exit 1 ; fi

ls $ZDOTDIR/greeters | nl

echo "choose a greeter"
read greeter

ln -sf $(echo $ZDOTDIR/greeters/* | cut -d" " -f$greeter) $ZDOTDIR/zsh-greeter
