#!/bin/sh


# This file is part of mydot.

# mydot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.

# mydot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with mydot.  If not, see <https://www.gnu.org/licenses/>.

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License

# ~/.profile: executed by the command interpreter for LOGIN shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.


# Shellcheck

# Ignore "Can't follow non-constant source."
# We just don't carea bout that
# shellcheck disable=1090
# https://github.com/koalaman/shellcheck/wiki/SC1090

# Ignore "Expressions don't expand in single quotes,
#         use double quotes for that."
# We want that for aliases
# shellcheck disable=2016
# https://github.com/koalaman/shellcheck/wiki/SC2016

# Ignore "For loops over find output are fragile.
#         Use find -exec or a while read loop."
# We nned to pass a function defined here and 'find -exec' does not support that
# shellcheck disable=2044
# https://github.com/koalaman/shellcheck/wiki/SC2044

# Ignore "This expands when defined, not when used. Consider escaping."
# We want that for aliases
# shellcheck disable=2139
# https://github.com/koalaman/shellcheck/wiki/SC2139

# Ignore "Possible misspelling: ZCACHEDIR may not be assigned,
#         but CCACHE_DIR is."
# shellcheck disable=2153
# https://github.com/koalaman/shellcheck/wiki/SC2153


# Helper functions

_functon_usage_end() {
    echo
    echo "keep in mind this is a shell function and"
    echo "(in)correct output from it may not be visible"
    return 1
}

# Send stdout and stderr of 'command' to /dev/null
# Basically this will return the exit status
nullwrap() {
    "${@}" >/dev/null 2>&1
}

command_exists() {
    if [ -z "${1}" ]
    then
        echo "Usage: command_exists COMMAND"
        echo "command_exists - check if COMMAND exists"
        _functon_usage_end
    else
        if nullwrap type "${1}"
        then
            return 0
        else
            return 1
        fi
    fi
}

a_k_a() {
    if [ -z "${2}" ]
    then
        echo "Usage: a_k_a ALIAS COMMAND"
        echo "a_k_a - safe alias"
        echo "will not create ALIAS if COMMAND is already occupied"
        _functon_usage_end
    else
        if ! command_exists "${1}"
        then
            alias "${1}"="${2}"
        fi
    fi
}

# For bigger cases just use if statement, see python below.
rbind() {
    if [ -z "${3}" ]
    then
        echo "Usage: rbind COMMAND1 ALIAS COMMAND2 [OPTION]"
        echo "rbind - alias COMMAND2 to ALIAS if COMMAND1 exists"
        echo
        echo "Options:"
        echo "    -s, --safe    don't alias if COMMAND2 already exists"
        echo "    -u, --unsafe  alias regardless of if COMMAND2 (default)"
        _functon_usage_end
    else
        if command_exists "${1}"
        then
            case "${4}"
            in
                "" | -u | -unsafe | --unsafe )
                    alias "${2}"="${3}"
                    ;;
                -s | -safe | --safe )
                    a_k_a "${2}" "${3}"
                    ;;
            esac
        fi
    fi

}

contains_string() {
    if [ -z "${2}" ]
    then
        echo "Usage: contains_string STRING1 STRING2"
        echo "contains_string - check if STRING1 contains STRING2"
        _functon_usage_end
    else
        if [ "${1#*${2}}" != "${1}" ]
        then
            return 0
        else
            return 1
        fi
    fi
}

add_to_path() {
    if [ -z "${1}" ]
    then
        echo "Usage: add_to_path PATH"
        echo "add_to_path - append given PATH to your PATH"
        echo "this function first checks if specified directory"
        echo "already is in PATH, if it is not and it exists"
        echo "it is added to the PATH"
        _functon_usage_end
    else
        if ! contains_string "${PATH}" "${1}"
        then
            if [ -d "${1}" ]
            then
                export PATH="${PATH}:${1}"
            fi
        fi
    fi
}

add_to_manpath() {
    if [ -z "${1}" ]
    then
        echo "Usage: add_to_manpath PATH"
        echo "add_to_manpath - append given PATH to your MANPATH"
        echo "this function first checks if specified directory"
        echo "already is in MANPATH, if it is not and it exists"
        echo "it is added to the MANPATH"
        _functon_usage_end
    else
        if ! contains_string "${MANPATH}" "${1}"
        then
            if [ -d "${1}" ]
            then
                export MANPATH="${MANPATH}:${1}"
            fi
        fi
    fi
}

# Are you root?
am_i_root() {
    if [ "$(whoami)" = "root" ]
    then
        return 0
    else
        return 1
    fi
}

mkcd() {
    if [ -z "${1}" ]
    then
        echo "Usage: mkcd PATH"
        echo "mkcd - make a directory and move into it"
        _functon_usage_end
    else
        mkdir -p "${*}"
        cd "${*}" || return 1
    fi
}

# Source a file if it exists
source_file() {
    if [ -z "${1}" ]
    then
        echo "Usage: source_file FILE"
        echo "source_file - source FILE if it exists"
        _functon_usage_end
    else
        [ -f "${1}" ] && . "${1}"
    fi
}


# System

# Failsafe PATH (because '[' and ']' are programs)
PATH="${PATH:-/bin:/sbin:/usr/bin:/usr/local/bin}"

# Source the system profile
source_file "/etc/profile"


# Terminal features

# Disable terminal scroll lock
command_exists stty && stty -ixon


# Environment

# User's name
# Keep this first
USER="${USER:-$(whoami)}"
export USER

# User's identification number
# Keep this second
if [ -z "${UID}" ] && command_exists id
then
    UID="$(id -u "${USER}")"
fi
export UID

# Auto-set the editor
if command_exists emacs
then
    if nullwrap pgrep -fi -u "${USER}" 'emacs --daemon'
    then
        EDITOR="emacsclient"
    else
        EDITOR="emacs"
    fi
else
    for editor in xemacs zile mg neovim vim vi nano ed
    do
        if command_exists "${editor}"
        then
            EDITOR="${editor}"
            break
        fi
    done
    unset editor
fi
export EDITOR

# Auto-set the pager
if [ -z "${PAGER}" ]
then
    for pager in less cat
    do
        if command_exists "${pager}"
        then
            PAGER="${pager}"
            break
        fi
    done
    unset pager
fi
export PAGER

# Aspell
# preferences settings
_aspell_dir="${HOME}/.config/aspell"
if nullwrap mkdir -p "${_aspell_dir}"
then
    _aspell_per_conf="per-conf ${_aspell_dir}/aspell.conf"
    _aspell_personal=""
    _aspell_repl=""

    for _lang in de en pl
    do
        _aspell_personal="${_aspell_personal} ${_aspell_dir}/${_lang}.pws"
        _aspell_repl="${_aspell_repl} ${_aspell_dir}/${_lang}.prepl"
    done

    ASPELL_CONF="per-conf ${_aspell_per_conf} ; personal ${_aspell_personal} ; repl ${_aspell_repl}"
    unset _aspell_per_conf _aspell_personal _aspell_repl
    export ASPELL_CONF
fi
unset _aspell_dir

# CCache
# Exclude root user - breaks ccache in portage
if am_i_root
then
    unset CCACHE_DIR
else
    # primary config is then ~/.cache/ccache/ccache.conf
    CCACHE_DIR="${HOME}/.cache/ccache"
    export CCACHE_DIR
fi

# Chez
# directory (used by aliases)
_chez_cache="${HOME}/.cache/chez"
if nullwrap mkdir -p "${_chez_cache}"
then
    CHEZ_HISTORY="${_chez_cache}/history"
    export CHEZ_HISTORY
fi
unset _chez_cache

# Conan
# color
CONAN_COLOR_DARK=1
export CONAN_COLOR_DARK
# directory
CONAN_USER_HOME="${HOME}/.local/share/conan"
export CONAN_USER_HOME

# .NET settings
# don't spy on me! Can you at least do that?
DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT

# Elixir
# hex directory
HEX_HOME="${HOME}/.local/share/elixir/hex"
export HEX_HOME
# mix directory
MIX_HOME="${HOME}/.local/share/elixir/mix"
export MIX_HOME

# Emacs (for now used only by the shell)
USER_EMACS_DIRECTORY="${HOME}/.config/emacs"
export USER_EMACS_DIRECTORY

# Erlang (OTP)
# history file (in ~/.cache/erlang-history)
ERL_AFLAGS="-kernel shell_history enabled"
export ERL_AFLAGS

# Go
# directory
GOPATH="${HOME}/.local/share/go"
export GOPATH

# GTK
# settings
if [ -f "${EPREFIX}/usr/libexec/xdg-desktop-portal" ]
then
    GTK_USE_PORTAL=1
    export GTK_USE_PORTAL
fi

# Guile
# history file
GUILE_HISTORY="${HOME}/.cache/guile/history"
export GUILE_HISTORY

# Java
GRADLE_USER_HOME="${HOME}/.cache/java/gradle"
export GRADLE_USER_HOME

# Julia
# directory
JULIA_DEPOT_PATH="${HOME}/.local/share/julia"
export JULIA_DEPOT_PATH

# Ls
# ls colors
_set_dircolors() {
    eval "$(dircolors -b | sed 's/01;05;37;41/0;36/g')"
    #                      ^ also replace blinking red with blue green
}
command_exists dircolors && _set_dircolors

# Less
# Disable less history file
LESSHISTFILE=-
export LESSHISTFILE

# LibDVDcss
# cache directory
DVDCSS_CACHE="${HOME}/.cache/dvdcss"
export DVDCSS_CACHE

# Maxima
# directory
_maxima_config="${HOME}/.config/maxima"
if nullwrap mkdir -p "${_maxima_config}/.maxima"
then
    MAXIMA_USERDIR="${_maxima_config}"
    export MAXIMA_USERDIR
fi
unset _maxima_config

# Mednafen
# configuration directory
MEDNAFEN_HOME="${HOME}/.config/mednafen"
export MEDNAFEN_HOME

# NCurses
# terminfo directories
TERMINFO="${HOME}/.local/share/terminfo"
export TERMINFO
TERMINFO_DIRS="${HOME}/.local/share/terminfo:/usr/share/terminfo:${TERMINFO_DIRS}"
export TERMINFO_DIRS

# NodeJS
# REPL history ; NodeJS can't recursively create it's directory
_nodejs_cache="${HOME}/.cache/nodejs"
if nullwrap mkdir -p "${_nodejs_cache}"
then
    NODE_REPL_HISTORY="${_nodejs_cache}/history"
    export NODE_REPL_HISTORY
fi
# NPM config
NPM_CONFIG_USERCONFIG="${HOME}/.config/npm/npmrc"
export NPM_CONFIG_USERCONFIG

# Octave
# history file
_octave_cache="${HOME}/.cache/octave"
if nullwrap mkdir -p "${_octave_cache}"
then
    OCTAVE_HISTFILE="${_octave_cache}/history"
    export OCTAVE_HISTFILE
fi
unset _octave_cache

# Python
# Ipython can't recursively create it's directory
_python_cache="${HOME}/.cache/python"
_python_config="${HOME}/.config/python"
_python_data="${HOME}/.local/share/python"
if nullwrap mkdir -p "${_python_cache}"
then
    # pip cache directory
    PIP_CACHE_DIR="${HOME}/.cache/python/pip"
    export PIP_CACHE_DIR
    # pylint directory
    PYLINTHOME="${HOME}/.cache/python/pylint"
    export PYLINTHOME
fi
if nullwrap mkdir -p "${_python_config}"
then
    # Jupyter directory
    JUPYTER_CONFIG_DIR="${_python_config}/jupyter"
    export JUPYTER_CONFIG_DIR
    nullwrap mkdir -p "${JUPYTER_CONFIG_DIR}"
fi
if nullwrap mkdir -p "${_python_data}"
then
    # Ipython directory
    IPYTHONDIR="${_python_data}/ipython"
    export IPYTHONDIR
    nullwrap mkdir -p "${IPYTHONDIR}"
fi
unset _python_cache
unset _python_config
unset _python_data

# OCaml
# opam directory
OPAMROOT="${HOME}/.local/share/ocaml/opam"
export OPAMROOT

# Racket directory
PLTUSERHOME="${HOME}/.local/share/racket"
export PLTUSERHOME

# Ruby
# gem directories
GEMRC="${HOME}/.config/ruby/gemrc"
export GEMRC
GEM_HOME="${HOME}/.local/share/ruby/gem"
export GEM_HOME
GEM_SPEC_CACHE="${HOME}/.cache/ruby/gem"
export GEM_SPEC_CACHE
# solargraph cache directory
SOLARGRAPH_CACHE="${HOME}/.cache/ruby/solargraph"
export SOLARGRAPH_CACHE

# Rust
# cargo directory
CARGO_HOME="${HOME}/.local/share/rust/cargo"
export CARGO_HOME

# Shell
# REPL history
mkdir -p "${HOME}/.cache/sh"
HISTFILE="${HOME}/.cache/sh/history"
export HISTFILE
HISTSIZE=50000
export HISTSIZE

# Latex
# TeX directories
TEXMFCONFIG="${HOME}/.config/texlive/texmf-config"
export TEXMFCONFIG
TEXMFHOME="${HOME}/.local/share/texlive/texmf"
export TEXMFHOME
TEXMFVAR="${HOME}/.cache/texlive/texmf-var"
export TEXMFVAR

# VSCode
# "portable" directory for storing settings and extensions
VSCODE_PORTABLE="${HOME}/.local/share/vscode"
export VSCODE_PORTABLE

# XDG Base Directory (general failsafe)
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
nullwrap mkdir -p "${XDG_CACHE_HOME}" && export XDG_CACHE_HOME
XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
nullwrap mkdir -p "${XDG_CONFIG_DIRS}" && export XDG_CONFIG_DIRS
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
nullwrap mkdir -p "${XDG_CONFIG_HOME}" && export XDG_CONFIG_HOME
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export XDG_DATA_DIRS
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
nullwrap mkdir -p "${XDG_DATA_HOME}" && export XDG_DATA_HOME
XDG_LOG_HOME="${XDG_LOG_HOME:-${HOME}/.local/var/log}"
nullwrap mkdir -p "${XDG_LOG_HOME}" && export XDG_LOG_HOME
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/var/lib}"
nullwrap mkdir -p "${XDG_STATE_HOME}" && export XDG_STATE_HOME

# XDG Runtime Directory (failsafe)
if [ -z "${XDG_RUNTIME_DIR}" ] || [ ! -d "${XDG_RUNTIME_DIR}" ]
then
    for _XDG_CAND_BASE in /run /tmp /tmp/xdg "/tmp/${USER}" "${XDG_CACHE_HOME}"
    do
        if nullwrap mkdir -p "${_XDG_CAND_BASE}/user/${UID}"
        then
            XDG_RUNTIME_DIR="${_XDG_CAND_BASE}/user/${UID}"
            break
        fi
    done
    unset _XDG_CAND_BASE
fi
export XDG_RUNTIME_DIR
nullwrap chmod 0700 "${XDG_RUNTIME_DIR}"

# Xorg X11 Server
# Why here? We use XDG_RUNTIME_DIR for Xauthority
XAUTHORITY="${XAUTHORITY:-${XDG_RUNTIME_DIR}/Xauthority}"
export XAUTHORITY
XINITRC="${HOME}/.config/X11/xinitrc"
export XINITRC
XSERVERRC="${HOME}/.config/X11/xserverrc"
export XSERVERRC

# ICE
_x11_cache="${HOME}/.cache/X11"
if nullwrap mkdir -p "${_x11_cache}"
then
    ICEAUTHORITY="${_x11_cache}/ICEauthority"
    export ICEAUTHORITY
fi
unset _x11_cache


# PATH setup

# Gentoo manuals (generated by MyDot)
add_to_manpath "${HOME}/.local/share/man/eclass"

# MyDot manuals
add_to_manpath "${HOME}/.local/share/man/mydot"

# User's manuals
add_to_manpath "${HOME}/.local/share/man"

# We also add old path for compatibility (ie. Cargo & NPM)
# the other one is the one exported by this profile file

# Common programs' homes
add_to_path "/bin"
add_to_path "/opt/bin"
add_to_path "/sbin"
add_to_path "/usr/bin"
add_to_path "/usr/libexec"
add_to_path "/usr/local/bin"
add_to_path "/usr/local/sbin"
add_to_path "/usr/sbin"

# Selected OPTional programs
add_to_path "/opt/src_prepare-scripts"
add_to_path "/usr/pkg/gnu/bin"

# Cabal (Haskell)
add_to_path "${HOME}/.cabal/bin"

# Cargo (Rust)
add_to_path "${HOME}/.cargo/bin"
add_to_path "${CARGO_HOME}/bin"

# GO
add_to_path "${GOPATH}/bin"

# Mix (Elixir) (mainly for rebar(3))
add_to_path "${MIX_HOME}"

# Nimble (Nim)
add_to_path "${HOME}/.local/share/nimble/bin"

# NPM (Node)
add_to_path "${HOME}/.npm/bin"
add_to_path "${HOME}/.local/share/npm/bin"

# Opam (OCaml)
add_to_path "${OPAMROOT}/default/bin"

# Python
add_to_path "${HOME}/.local/bin"

# Racket
if [ -d "${PLTUSERHOME}/.racket" ]
then
    # We loop to include all different Racket implementation directories
    # ~/.local/share/racket/.racket/7.0/bin or ~/.local/share/racket/.racket/7.7/bin
    for racket_bin_dir in $(find "${PLTUSERHOME}/.racket" -maxdepth 2 -name bin -type d)
    do
        add_to_path "${racket_bin_dir}"
    done
    unset racket_bin_dir
fi

# Ros(well) (Lisp)
add_to_path "${HOME}/.roswell/bin"

# Ruby (Gem)
add_to_path "${GEM_HOME}/bin"

# User's programs
# Keep this last
add_to_path "${HOME}/.bin"
add_to_path "${HOME}/.local/share/bin"


# Aliases

# NEED_UID0 is used in the following aliases
# Keep this after adding itens to PATH
# If we're root we don't need sudo in most cases (covered here)
if am_i_root || [ -n "${EPREFIX}" ]
then
    NEED_UID0=""
else
    for _NEED_UID0 in doas sudo odus
    do
        if command_exists "${_NEED_UID0}"
        then
            NEED_UID0="${_NEED_UID0}"
            a_k_a sudo "${_NEED_UID0}"
            break
        fi
    done
    unset _NEED_UID0
fi
export NEED_UID0

# Operating System specific
# !!! Keep this first !!!
case "$(uname)"
in
    *Linux* )
        alias l='ls -A'
        alias ll='ls --color=always -Fahl'
        alias ls='ls --color=auto --group-directories-first'
        rbind tree t    'tree -I ".git" -L 2 -a'
        rbind tree ta   'tree -I ".git" -a'
        rbind tree tree 'tree -CF'
        ;;
    * )
        alias l='ls -A'
        alias ll='ls -Fahl'
        rbind tree t    'tree -L 2 -a'
        rbind tree ta   'tree -a'
        rbind tree tree 'tree -F'
        ;;
esac

# Editor
# Don't sort this
rbind emacs e   'emacs -nw' -s
rbind emacs em  'emacs'     -s
a_k_a       e   '${EDITOR}'
rbind nano  n   'nano'      -s
a_k_a       n   '${EDITOR}'
rbind vim   v   'vim'       -s
a_k_a       v   '${EDITOR}'
rbind nvim  vim 'nvim'
rbind vim   vi  'vim'
rbind codium-bin codium 'codium-bin' -s
rbind codium     code 'codium'       -s

# Files
a_k_a ',,'   'cd ../..'
a_k_a ',,,,' 'cd ../../../..'
a_k_a '..'   'cd ..'
a_k_a '....' 'cd ../..'
a_k_a nuke   'rm -fr'
a_k_a tf     'tail -fv --retry'
rbind ncdu      ncdu 'ncdu --color=dark'
rbind highlight hl   'highlight -O truecolor'   -s
rbind rsync     rcp  'rsync --stats --progress' -s
rbind xdg-open  open 'xdg-open'                 -s

# Git
_alias_git() {
    a_k_a G   'git'
    a_k_a GA  'git add .'
    a_k_a Ga  'git add'
    a_k_a Gc  'git commit --signoff'
    a_k_a Gcc 'git log --cc --color-moved --show-signature'
    a_k_a Gd  'git diff --color-moved'
    a_k_a Gg  'git pull'
    a_k_a Gl  'git log --oneline --graph'
    a_k_a Go  'git clone --recursive --verbose'
    a_k_a Gp  'git push'
    a_k_a Gq  'git add . && git commit --signoff && git pull --rebase && git push'
    a_k_a Gr  'git reset --hard'
    a_k_a Gs  'git status'
    a_k_a Gu  'git reset HEAD --'
}
command_exists git && _alias_git

# Multimedia
a_k_a ffsound 'ffplay -nodisp -hide_banner'

# Network
a_k_a no-net-sh 'unshare -r -n ${SH}'
rbind mtr      mtr  'mtr --show-ips --curses'
rbind w3m      w3m  'HOME="${HOME}/.cache" w3m'
rbind arp-scan seen '${NEED_UID0} watch arp-scan --localnet' -s
rbind netstat  seeo '${NEED_UID0} netstat -acnptu'           -s

# Other PKG managers
rbind flatpak fpk          'flatpak --user'                                             -s
rbind flatpak fpkup        'flatpak --user update && flatpak --user uninstall --unused' -s
rbind raco    raco-install 'raco pkg install --jobs $(nproc) --auto --user'             -s

# Portage
_alias_portage() {
    a_k_a B      'tail -fv "$(portageq envvar PORTAGE_TMPDIR)"/portage/*/*/temp/build.log'
    a_k_a E      'tail -fv ${EPREFIX}/var/log/emerge.log'
    a_k_a F      'tail -fv ${EPREFIX}/var/log/emerge-fetch.log'
    a_k_a P      'cd ${EPREFIX}/etc/portage && tree -a -L 2'
    a_k_a chu    '${NEED_UID0} emerge -avU --changed-deps --changed-slot --with-bdeps=y --backtrack=100 @world'
    a_k_a des    '${NEED_UID0} emerge --deselect'
    a_k_a ewup   '${NEED_UID0} emerge -avuDU --with-bdeps=y --backtrack=100 --verbose-conflicts @world'
    a_k_a pep    '${NEED_UID0} emerge --autounmask --ask --verbose'
    a_k_a preb   '${NEED_UID0} emerge --usepkg-exclude "*" -1 @preserved-rebuild'
    a_k_a slr    '${NEED_UID0} smart-live-rebuild -- --usepkg-exclude "*"'
    a_k_a vmerge '${NEED_UID0} emerge --verbose --jobs=1 --quiet-build=n'
}
command_exists emerge && _alias_portage

# System tools
rbind tmux   T   'tmux attach || tmux'

# Programming
# The following will attempt to alias 'python' as 'python3'
# if 'python' doesnt exist, also it creates 'py2'/'py3' aliases
_alias_python3() {
    a_k_a py3 'python3'
    a_k_a python 'python3'
}
_alias_python2() {
    a_k_a py2 'python2'
    a_k_a python 'python2'
}
if command_exists python3
then
    _alias_python3
elif command_exists python2
then
    _alias_python2
fi
a_k_a builddir 'mkdir -p ./build && cd ./build'
rbind chez       chez       'chez --eehistory "${CHEZ_HISTORY}"'
rbind chezscheme chezscheme 'chezscheme --eehistory "${CHEZ_HISTORY}"'
rbind petite     petite     'petite --eehistory "${CHEZ_HISTORY}"'
rbind chezscheme chez       'chezscheme'          -s
rbind firefox    ff         'firefox'             -s
rbind ghci       hs         'ghci'                -s
rbind git        diff-git   'git diff --no-index' -s
rbind ipython    ipy        'ipython'             -s
rbind irb        rb         'irb'                 -s
rbind julia      jl         'julia'               -s
rbind perl       iperl      'perl -de0'           -s
rbind python     py         'python'              -s
rbind racket     rkt        'racket'              -s
rbind scheme     scm        'scheme'              -s
rbind tclsh      tcl        'tclsh'               -s

# Shell
a_k_a shell       '${SHELL}'
_alias_sh() {
    a_k_a ed-shrc     '${EDITOR} ${HOME}/.profile'
    a_k_a so-shrc     'source ${HOME}/.profile'
}
command_exists sh && _alias_sh
_alias_bash() {
    a_k_a cl-history  'cat /dev/null > ${HISTFILE}'
    a_k_a ed-bashrc   '${EDITOR} ${HOME}/.bashrc'
    a_k_a so-bashrc   'source ${HOME}/.bashrc'
}
command_exists bash && _alias_bash
_alias_zsh() {
    a_k_a cl-zhistory 'cat /dev/null > ${ZCACHEDIR}/history'
    a_k_a ed-zshrc    '${EDITOR} ${ZDOTDIR}/.zshrc'
    a_k_a so-zshrc    'source ${ZDOTDIR}/.zshrc'
}
command_exists zsh && _alias_zsh

# System
a_k_a cpuinfo     'cat /proc/cpuinfo'
a_k_a kerr        '${NEED_UID0} dmesg --level=alert,crit,emerg,err,warn --time-format=reltime --color'
a_k_a man-pl      'LANG="pl_PL.UTF-8" man'
a_k_a root        'su -l root'
a_k_a rp          '${NEED_UID0} '
a_k_a running     '(env | sort ; alias ; functions) 2>/dev/null | ${PAGER}'
rbind grub-mkconfig update-grub '${NEED_UID0} grub-mkconfig -o /boot/grub/grub.cfg' -s

# Busybox
# !!! Keep this last !!!
# If BB is installed, then try to get unavailable programs from it
_alias_busybox() {
    for _bb_impl in $(busybox --list)
    do
        a_k_a "${_bb_impl}" "busybox ${_bb_impl}"
    done
    unset _bb_impl
}
command_exists busybox && _alias_busybox


# Prompt theme

PS1="(SH)> "
export PS1

PS2="... "
export PS2


# Autostart the GPG Agent

# Export some vars
GPG_TTY="$(tty)"
export GPG_TTY
PINENTRY_USER_DATA="USE_CURSES=1"
export PINENTRY_USER_DATA

# Start GPG agent if it is not running
_start_agent_gpg() {
    nullwrap pgrep -i -u "${USER}" gpg-agent || gpg-agent --daemon 2>/dev/null
}

# Check if GPG agent exists
if ! am_i_root && command_exists gpg-agent
then
    _start_agent_gpg
fi


# Autostart the SSH Agent

# Start SSH agent if it is not running
_start_agent_ssh() {
    nullwrap pgrep -i -u "${USER}" ssh-agent  \
        || ssh-agent > "${XDG_RUNTIME_DIR}/ssh-agent.env"

    [ -e "${SSH_AUTH_SOCK}" ]  \
        || nullwrap eval "$(cat "${XDG_RUNTIME_DIR}/ssh-agent.env")"
}

# Check if SSH agent and XDG runtime directory exist
if ! am_i_root && command_exists ssh-agent && [ -d "${XDG_RUNTIME_DIR}" ]
then
    _start_agent_ssh
fi


# Additional source

# I guess that GPG and SSH agents
# don't need to be in separate files

# Source additional files
# that are not critical to running the shell
_source_config() {
    for _shext in "${HOME}/.config/sh"/?*
    do
        source_file "${_shext}"
    done
    unset _shext
    return 0
}

[ -d "${HOME}/.config/sh" ] && _source_config
