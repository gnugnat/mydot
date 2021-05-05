#!/usr/bin/env zsh


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

# Based on:
# https://docs.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete

# shellcheck disable=2034


_dotnet_zsh_complete() {
    local completions=( "$(dotnet complete "${words}")" )

    reply=( "${(ps:\n:)completions}" )
}


compctl -K _dotnet_zsh_complete dotnet
