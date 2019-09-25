#!/usr/bin/env zsh

if [ -z $ZDOTDIR ]; then echo "No ZDOTDIR set, exiting..."; exit 1 ; fi

ls $ZDOTDIR/themes | nl

echo "choose a tty theme"
read tty_zsh_theme
echo "choose a emulator theme"
read emu_zsh_tmeme

ln -sf $(echo $ZDOTDIR/themes/* | cut -d" " -f$tty_zsh_theme) $ZDOTDIR/tty.zsh-theme
ln -sf $(echo $ZDOTDIR/themes/* | cut -d" " -f$emu_zsh_tmeme) $ZDOTDIR/emu.zsh-theme
