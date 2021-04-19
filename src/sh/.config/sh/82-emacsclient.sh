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

# Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License

# Emacsclient

# shellcheck disable=2016


if command_exists emacsclient
then
    unalias emd >/dev/null 2>&1

    # TUI
    alias emc='emacsclient -a ""'
    a_k_a emct 'emc -nw'

    # GUI
    a_k_a emcf 'emc -n -c'
    a_k_a emcg 'emc -n -c --eval "(config-load)"'

    emd() {
        case "${1}"
        in
            rmel | remove-el | remove-generated )
                echo "Removing generated configuration files..."
                rm "${USER_EMACS_DIRECTORY}/config.el"
                ;;
            reload )
                echo "Relaoding..."
                emd rmel
                emacsclient -n --eval "(config-load)"
                ;;
            "" | start )
                echo "Starting..."
                emd rmel
                emacs --daemon
                ;;
            stop )
                echo "Stopping..."
                emacsclient -n --eval "(kill-emacs)"
                ;;
            restart )
                echo "Restarting..."
                emd stop
                emd start
                ;;
            * )
                echo "Use: rmel | relaod | start | stop | restart"
                return 1
                ;;
        esac
    }
fi
