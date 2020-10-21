#!/bin/sh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License


loadavg_file=/proc/loadavg


if [ -f ${loadavg_file} ]
then
    printf "%s" "$(cut -d ' ' -f -1 ${loadavg_file})"
fi
