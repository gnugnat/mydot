#!/bin/sh


# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the ISC License


loadavg_file=/proc/loadavg


if [ -f ${loadavg_file} ]
then
    printf "%s" "$(cut -d ' ' -f -1 ${loadavg_file})"
fi
