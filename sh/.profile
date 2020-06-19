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
    # shellcheck disable=1090
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
        if ! command -v "${1}" >/dev/null 2>&1
        then
            # shellcheck disable=2139,2140
            alias "${1}"="cd ${2} && echo ' * Changed the Directory to' ${2}"
        fi
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

# Open current directory in Emacs dired
# $@ (any) - a additional flag, i.e. -nw
dired() {
    eval emacs "${@}" \
         --eval "'(dired nil)'"
}

# >>> Environment

# Source the system profile
[ -e /etc/profile ] && . /etc/profile

# If EDITOR variable is empty set the editor to nano
[ -z "$EDITOR" ] && export EDITOR=nano

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
        alias ls='ls --color=auto'
        alias ll='ls -lahF --color=always'
        alias grep='grep --colour=always'
        alias tree='tree -C -F'
        alias t='tree -a -L 2 -I ".git"'
        ;;
    *)
        alias ll='ls -lahF'
        alias tree='tree -F'
        alias t='tree -a -L 2'
        ;;
esac

# System
alias rp='sudo '
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Network
alias mtr='mtr --show-ips --curses'
alias seen='sudo watch arp-scan --localnet'
alias seeo='sudo netstat -acnptu'

# Editing
alias ,,='cd ../..'
alias e='emacs -nw'
alias n='nano'
alias v='vim'
alias hl='highlight -O truecolor'
alias nuke='rm -rfd'
alias nranger='EDITOR=nano ranger'
alias open='xdg-open'
alias rcp='rsync --stats --progress'

# Shell
alias ed-shrc='${EDITOR} ${HOME}/.profile'
alias so-shrc='source ${HOME}/.profile'
alias clear-zhistory='cat /dev/null > ${ZCACHEDIR}/zhistory'
alias ed-bashrc='${EDITOR} ${HOME}/.bashrc'
alias so-bashrc='source ${HOME}/.bashrc'
alias clear-zhistory='cat /dev/null > ${ZCACHEDIR}/zhistory'
alias ed-zshrc='${EDITOR} ${ZDOTDIR}/.zshrc'
alias so-zshrc='source ${ZDOTDIR}/.zshrc'

# Git
alias Ga='git add .'
alias Gc='git commit'
alias Gd='git diff'
alias Gg='git pull'
alias Gl='git log --oneline --graph'
alias Go='git clone --recursive --verbose'
alias Gp='git push'
alias Gr='git reset --hard'
alias Gs='git status'

# Programming
alias py='python'
alias rkt='racket'

# Portage
alias E='tail -f ${EPREFIX}/var/log/emerge.log'
alias F='tail -f ${EPREFIX}/var/log/emerge-fetch.log'
alias P='cd ${EPREFIX}/etc/portage && tree -a -L 2'

alias pep='sudo emerge -av'
alias chu='sudo emerge -avNUD @world'
alias ewup='sudo emerge -avuDNU --with-bdeps=y @world'
alias slr='sudo smart-live-rebuild'

# Other PKG managers
alias fpk='flatpak'

# youtube-dl
alias ytd='youtube-dl -i -o "%(title)s.%(ext)s"'
alias ytd-bestaudio='youtube-dl -i -f bestaudio -x -o "%(playlist_index)s - %(title)s.%(ext)s"'
alias ytd-flac='youtube-dl -i -f bestaudio -x --audio-format flac -o "%(playlist_index)s - %(title)s.%(ext)s"'
alias ytd-mp3='youtube-dl -i -f bestaudio -x --audio-format mp3 -o "%(playlist_index)s - %(title)s.%(ext)s"'
alias ytd-opus='youtube-dl -i -f bestaudio -x --audio-format opus -o "%(playlist_index)s - %(title)s.%(ext)s"'
alias ytd-webm='youtube-dl -i --format webm -o "%(title)s.%(ext)s"'
alias ytd-sub-en='youtube-dl -i --write-srt --sub-lang en -o "%(title)s.%(ext)s"'
alias ytd-sub-pl='youtube-dl -i --write-srt --sub-lang pl -o "%(title)s.%(ext)s"'


# >>> Change-directory aliases

# If "functions" can be sourced
# shellcheck disable=1090

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
