#!/bin/sh

if [ -z $MYZSHDIR ]; then echo "No MYZSHDIR set, exiting..."; exit 1 ; fi
greeterdir=$MYZSHDIR/greeters
greeters=$(ls $greeterdir)

ls $greeterdir | nl

echo "choose a greeter"
read greeter

ln -sf $greeterdir/$(echo $greeters | cut -d" " -f$greeter) $MYZSHDIR/zsh-greeter
