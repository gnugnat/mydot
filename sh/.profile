#!/bin/sh


#      _
#  ___| |__
# / __| '_ \
# \__ \ | | |
# |___/_| |_|
# ~/.profile

# ~/.profile: executed by the command interpreter for LOGIN shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.


# >>> Shellcheck

# Ignore "Can't follow non-constant source."
# We just don't carea bout that
# shellcheck disable=1090
# https://github.com/koalaman/shellcheck/wiki/SC1090

# Ignore "Expressions don't expand in single quotes, use double quotes for that."
# We want that for aliases
# shellcheck disable=2016
# https://github.com/koalaman/shellcheck/wiki/SC2016

# Ignore "This expands when defined, not when used. Consider escaping."
# We want that for aliases
# shellcheck disable=2139
# https://github.com/koalaman/shellcheck/wiki/SC2139


# >>> Helper functions

# Check if 1st string contains the 2nd
contains_string() {
    string="${1}"
    substring="${2}"

    if [ "${string#*${substring}}" != "${string}" ]
    then
        # $substring is in $string
        return 0
    else
        # $substring is not in $string
        return 1
    fi
}

# Source a file if it exists
source_file() {
    [ -f "${1}" ] && . "${1}"
}

# Add a directory to PATH
# This function first checks if specified directory
# already is in path, if it is not and it exists
# it is added to the path
add_to_path() {
    if ! contains_string "${PATH}" "${1}"
    then
        if [ -d "${1}" ]
        then
            export PATH=${PATH}:${1}
        fi
    fi
}

# A.K.A - safe alias
# create a alias only if a command and/or alias
# with the desired name does not exist
a_k_a() {
    if ! alias "${1}" >/dev/null 2>&1
    then
       if ! command -v "${1}" >/dev/null 2>&1
       then
           alias "${1}"="${2}"
       fi
    fi
}

# Change-directory alias
# ${1} - alias name
# ${2} - directory
# Example:
#   cd_alias etc /etc
#   Means:
#     alias etc="cd /etc && echo * Changed the Directory to etc"
cd_alias() {
    # If ${1} is not already in use
    if [ -d "${2}" ]
    then
        a_k_a "${1}" "cd ${2} && echo ' * Changed the Directory to' ${2}"
    fi
}

# Make a directory and cd into it
mkcd() {
    mkdir "${1}" && cd "${1}" || return 1
}

# Open a link in Emacs web browser
# $1 - URL
# $2 - a additional flag, i.e. -nw
eww() {
    eval emacs "${2}" \
         --eval "'(eww" "\"" "${1}" "\"" ")'"
}


# >>> Environment

# Source the system profile
[ -e /etc/profile ] && . /etc/profile

# If EDITOR variable is empty set the editor to nano
[ -z "$EDITOR" ] && export EDITOR=nano

# Disable less history file
export LESSHISTFILE=-

# Guile history file
GUILE_HISTORY=${HOME}/.cache/guile/history
export GUILE_HISTORY


# >>> PATH setup

# Common programs' homes
add_to_path /bin
add_to_path /opt/bin
add_to_path /sbin
add_to_path /usr/bin
add_to_path /usr/local/bin
add_to_path /usr/local/sbin
add_to_path /usr/sbin

# User's programs
add_to_path "${HOME}/.bin"
add_to_path "${HOME}/.local/share/bin"

# Cabal (Haskell)
add_to_path "${HOME}/.cabal/bin"

# Cargo (Rust)
add_to_path "${HOME}/.cargo/bin"

# GO
add_to_path "${HOME}/go/bin"

# Node
add_to_path "${HOME}/.npm/bin"

# Python
add_to_path "${HOME}/.local/bin"


# >>> Aliases

# Operating System specific
case $(uname)
in
    *Linux*)
        a_k_a ll 'ls -lahF --color=always'
        a_k_a t 'tree -a -L 2 -I ".git"'
        alias grep='grep --colour=always'
        alias ls='ls --color=auto'
        alias tree='tree -C -F'
        ;;
    *)
        a_k_a ll 'ls -lahF'
        a_k_a t 'tree -a -L 2'
        alias tree='tree -F'
        ;;
esac

# System
a_k_a rp 'sudo '
a_k_a update-grub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Network
a_k_a seen 'sudo watch arp-scan --localnet'
a_k_a seeo 'sudo netstat -acnptu'
alias mtr='mtr --show-ips --curses'

# Editing
a_k_a ,, 'cd ../..'
a_k_a e 'emacs -nw'
a_k_a eq 'emacs -Q -nw --eval "(setq auto-save-default nil create-lockfiles nil make-backup-files nil scroll-conservatively 100 x-select-enable-clipboard-manager nil)"'
a_k_a hl 'highlight -O truecolor'
a_k_a n 'nano'
a_k_a nranger 'EDITOR=nano ranger'
a_k_a nuke 'rm -rfd'
a_k_a open 'xdg-open'
a_k_a rcp 'rsync --stats --progress'
a_k_a v 'vim'


# Shell
a_k_a ed-shrc '${EDITOR} ${HOME}/.profile'
a_k_a so-shrc 'source ${HOME}/.profile'
a_k_a clear-zhistory 'cat /dev/null > ${ZCACHEDIR}/zhistory'
a_k_a ed-bashrc '${EDITOR} ${HOME}/.bashrc'
a_k_a so-bashrc 'source ${HOME}/.bashrc'
a_k_a clear-zhistory 'cat /dev/null > ${ZCACHEDIR}/zhistory'
a_k_a ed-zshrc '${EDITOR} ${ZDOTDIR}/.zshrc'
a_k_a so-zshrc 'source ${ZDOTDIR}/.zshrc'

# Git
a_k_a Ga 'git add .'
a_k_a Gc 'git commit'
a_k_a Gd 'git diff'
a_k_a Gg 'git pull'
a_k_a Gl 'git log --oneline --graph'
a_k_a Go 'git clone --recursive --verbose'
a_k_a Gp 'git push'
a_k_a Gr 'git reset --hard'
a_k_a Gs 'git status'

# Programming
a_k_a py 'python'
a_k_a rkt 'racket'

# Portage
a_k_a E 'tail -f ${EPREFIX}/var/log/emerge.log'
a_k_a F 'tail -f ${EPREFIX}/var/log/emerge-fetch.log'
a_k_a P 'cd ${EPREFIX}/etc/portage && tree -a -L 2'

a_k_a pep 'sudo emerge -av'
a_k_a chu 'sudo emerge -avNUD @world'
a_k_a ewup 'sudo emerge -avuDNU --with-bdeps=y @world'
a_k_a slr 'sudo smart-live-rebuild'

# Other PKG managers
a_k_a fpk 'flatpak'

# youtube-dl
a_k_a ytd 'youtube-dl -i -o "%(title)s.%(ext)s"'
a_k_a ytd-bestaudio 'youtube-dl -i -f bestaudio -x -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-flac 'youtube-dl -i -f bestaudio -x --audio-format flac -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-mp3 'youtube-dl -i -f bestaudio -x --audio-format mp3 -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-opus 'youtube-dl -i -f bestaudio -x --audio-format opus -o "%(playlist_index)s - %(title)s.%(ext)s"'
a_k_a ytd-webm 'youtube-dl -i --format webm -o "%(title)s.%(ext)s"'
a_k_a ytd-sub-en 'youtube-dl -i --write-srt --sub-lang en -o "%(title)s.%(ext)s"'
a_k_a ytd-sub-pl 'youtube-dl -i --write-srt --sub-lang pl -o "%(title)s.%(ext)s"'


# >>> Change-directory aliases

# Compatibility (should get overwritten)
cd_alias mydot "${HOME}"/mydot

# System
cd_alias conf /etc/conf.d
cd_alias gentoo-tree /var/db/repos/gentoo
cd_alias linux-src /usr/src/linux
cd_alias localht /var/www/localhost/htdocs
cd_alias logs /var/log
cd_alias services /etc/init.d
cd_alias tmp /tmp
cd_alias www /var/www

# User - standard
cd_alias data "${HOME}"/Data
cd_alias desktop "${HOME}"/Desktop
cd_alias diary "${HOME}"/Documents/Diary
cd_alias documents "${HOME}"/Documents
cd_alias downloads "${HOME}"/Downloads
cd_alias games "${HOME}"/Games
cd_alias music "${HOME}"/Music
cd_alias pictures "${HOME}"/Pictures
cd_alias programming "${HOME}"/Documents/Programming
cd_alias videos "${HOME}"/Videos

# User - git
cd_alias eternal "${HOME}"/Git/eternal
cd_alias gentoo-dev "${HOME}"/Git/gentoo
cd_alias guru "${HOME}"/Git/gentoo/guru
cd_alias mine "${HOME}"/Git/mine
cd_alias mydot "${HOME}"/Git/mine/mydot
cd_alias other "${HOME}"/Git/other
cd_alias pre "${HOME}"/Git/pre
cd_alias src_ "${HOME}"/Git/src_prepare
cd_alias src_overlay "${HOME}"/Git/src_prepare/src_prepare-overlay

# User - hidden
cd_alias applications "${HOME}"/.local/share/applications
cd_alias apps "${HOME}"/.local/share/applications
cd_alias autostart "${HOME}"/.config/autostart
cd_alias bins "${HOME}"/.bin
cd_alias config "${HOME}"/.config
cd_alias zcachedir "${ZCACHEDIR}"
cd_alias zdotdir "${ZDOTDIR}"


# >>> Prompt theme

PS1="(SH)> "
export PS1

PS2="└── "
export PS2
