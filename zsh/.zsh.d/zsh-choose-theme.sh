#!/bin/sh

if [ -z $MYZSHDIR ]; then echo "No MYZSHDIR set, exiting..."; exit 1 ; fi
themedir=$MYZSHDIR/themes
themes=$(ls $themedir)

ls $themedir | nl

echo "choose a tty theme"
read tty_zsh_theme
echo "choose a emulator theme"
read emu_zsh_tmeme

ln -sf $themedir/$(echo $themes | cut -d" " -f$tty_zsh_theme) $MYZSHDIR/tty.zsh-theme
ln -sf $themedir/$(echo $themes | cut -d" " -f$emu_zsh_tmeme) $MYZSHDIR/emu.zsh-theme
