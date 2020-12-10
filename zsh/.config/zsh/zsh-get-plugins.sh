#!/usr/bin/env zsh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License

# Get the required zsh plugins


# set ZDOTDIR if it is not set
ZDOTDIR=${ZDOTDIR:-${HOME}/.config/zsh}


ask_for_download() {

    # input: "user/repo" on Github
    plugin_name="$(basename ${1})"

    echo
    tput bold
    echo "Download ${plugin_name}? [Y/n]"
    tput sgr0

    read -r dow_ans

    case ${dow_ans} in
        [nN][oO]|[nN])
            echo "Not downloading ${plugin_name}"
            ;;
        *)
            plugin_home="${ZDOTDIR}/plugins/${plugin_name}"
            if [ -d "${plugin_home}" ]
            then
                cd "${plugin_home}"
                git pull -v
            else
                git clone -v "https://github.com/${1}" "${plugin_home}"
            fi
            ;;
    esac

    unset plugin_name
    unset dow_ans
}


# Check if git exists
if ! command -v git >/dev/null
then
    echo "No git found, exiting"
    exit 1
fi

# Make the plugins directory
mkdir -p "$ZDOTDIR/plugins"

# Plugins:
ask_for_download zsh-users/zsh-syntax-highlighting
ask_for_download zsh-users/zsh-autosuggestions

# Finish
echo
tput bold
echo "Finished downloading plugins"
tput sgr0
echo
