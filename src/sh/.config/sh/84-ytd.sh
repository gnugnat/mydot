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

# This file is meant to be sourced by ~/.profile from mydot

# Youtube-Dl aliases


if command_exists youtube-dl
then

    alias youtube-dl='youtube-dl -i -o "%(title)s.%(ext)s"'
    a_k_a ytd           'youtube-dl'

    # audio
    alias ytd-bestaudio='youtube-dl -f bestaudio -x -o "%(playlist_index)s - %(title)s.%(ext)s"'
    a_k_a ytd-flac      'ytd-bestaudio --audio-format flac'
    a_k_a ytd-mp3       'ytd-bestaudio --audio-format mp3'
    a_k_a ytd-opus      'ytd-bestaudio --audio-format opus'

    # video
    a_k_a ytd-mp4       'youtube-dl -f mp4'
    a_k_a ytd-webm      'youtube-dl -f webm'

    # subs
    a_k_a ytd-sub-de    'youtube-dl --write-srt --sub-lang de'
    a_k_a ytd-sub-en    'youtube-dl --write-srt --sub-lang en'
    a_k_a ytd-sub-pl    'youtube-dl --write-srt --sub-lang pl'
fi
