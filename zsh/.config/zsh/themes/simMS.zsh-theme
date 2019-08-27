#!/usr/bin/env zsh

win_path () {
    pwd | tr '/' '\\'
}

PROMPT=$'C:`win_path`%B>%b '
