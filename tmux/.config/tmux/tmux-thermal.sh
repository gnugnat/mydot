#!/bin/sh


# Copyright (c) 2020-2021, Maciej Barć <xgqt@protonmail.com>
# Licensed under the ISC License


thermal_zone=/sys/devices/virtual/thermal/thermal_zone0/temp


if [ -f $thermal_zone ]
then
    printf "%s°C" $(($(cat $thermal_zone) / 1000))
fi
