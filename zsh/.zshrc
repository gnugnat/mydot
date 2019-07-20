#!/bin/zsh

#          _
#  _______| |__  _ __ ___
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__
# /___|___/_| |_|_|  \___|

### Scripts
#
# add additional programs to PATH
export PATH=$PATH:$HOME/.local/share/bin:$HOME/.local/bin:$HOME/go/bin

### Completion
#
# Load compinit
autoload -U compinit
compinit
#
# Advanced tab-completion
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' menu select
#
# Correction
setopt correctall

### History
#
# Necessary to save history
HISTFILE=$HOME/.zsh_history
HISTSIZE=3000
SAVEHIST=$HISTSIZE
#
# Ignore duplicates
setopt hist_ignore_all_dups
#
# Ignore space
setopt hist_ignore_space
#
# Save immediatelly, share history between terminals
setopt share_history

### Keys
#
# Kill & Yank
# for this set Emacs key bindings
bindkey -e
#
# Ctrl-left and Ctrl-right
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
#
# Del, Home and End
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
#
# Reverse search
bindkey '^R' history-incremental-search-backward
#
# Remove C-d binding (list-choices/delete-char-or-list)
bindkey -r '^D'

### Aliases
#
# Source shell-agnostic aliases
. $MYZSHDIR/aliases

### Theme
#
# Prompt init
autoload -U promptinit
promptinit
#
# Set themes
if [[ -z $DISPLAY ]]; then
    # theme in tty
    source "$MYZSHDIR/tty.zsh-theme"
else
    # theme in emulators
    source "$MYZSHDIR/emu.zsh-theme"
fi

### Plugins
#
# Autosuggestions
plugin_as=$MYZSHDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f $plugin_as ] && source $plugin_as
#
# Syntax coloring
plugin_sh=$MYZSHDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f $plugin_sh ] && source $plugin_sh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
#
# Check Git branch
git_check () {
    branch=$(git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    [ ! -z $branch ] && echo "$pre_git_check$branch$post_git_check"
}

### Miscellaneous settings
#
# Prompt Substring
# used by git_check
setopt PROMPT_SUBST
#
# Extendedglob
setopt extendedglob
#
# Color
use_color=true
#
# directory name to change dir
setopt autocd
#
# do not beep
unsetopt beep
#
# Command Editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
#
# Change the window title of X terminals
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;${USER}@${HOST}:${PWD/#$HOME/\~}\a"};;
esac
#
# ls after changing directory
chpwd() ls
