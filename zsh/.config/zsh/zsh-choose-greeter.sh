#!/bin/sh

if [ -z $ZDOTDIR ]; then echo "No ZDOTDIR set, exiting..."; exit 1 ; fi
greeterdir=$ZDOTDIR/greeters
greeters=$(ls $greeterdir)

ls $greeterdir | nl

echo "choose a greeter"
read greeter

ln -sf $greeterdir/$(echo $greeters | cut -d" " -f$greeter) $ZDOTDIR/zsh-greeter
