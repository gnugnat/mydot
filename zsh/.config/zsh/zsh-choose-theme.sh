#!/bin/sh

if [ -z $ZDOTDIR ]; then echo "No ZDOTDIR set, exiting..."; exit 1 ; fi
themedir=$ZDOTDIR/themes
themes=$(ls $themedir)

ls $themedir | nl

echo "choose a tty theme"
read tty_zsh_theme
echo "choose a emulator theme"
read emu_zsh_tmeme

ln -sf $themedir/$(echo $themes | cut -d" " -f$tty_zsh_theme) $ZDOTDIR/tty.zsh-theme
ln -sf $themedir/$(echo $themes | cut -d" " -f$emu_zsh_tmeme) $ZDOTDIR/emu.zsh-theme
