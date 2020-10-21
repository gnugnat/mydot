#!/usr/bin/env zsh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License


win_path () {
    pwd | tr '/' '\\'
}

PROMPT=$'C:$(win_path)%B>%b '
