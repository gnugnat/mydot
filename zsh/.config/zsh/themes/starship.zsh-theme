#!/usr/bin/env zsh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License

# Install starship first
# https://starship.rs/guide/


if command_exists starship
then
    eval "$(starship init zsh)"
else
    echo "starship not found"
fi
