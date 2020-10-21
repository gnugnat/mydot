#!/bin/sh


# Copyright (c) 2020, XGQT
# Licensed under the ISC License


totalseconds=$(awk -F . '{print $1}' < /proc/uptime)

seconds=$((totalseconds % 60))
minutes=$(((totalseconds / 60) % 60))
hours=$(((totalseconds / 3600) % 24))
days=$((totalseconds / 86400))


if [ $days != 0 ]
then
    printf "%sd, " $days
fi
if [ $hours != 0 ]
then
    printf "%sh, " $hours
fi
if [ $minutes != 0 ]
then
    printf "%sm" $minutes
else
    printf "%ss" $seconds
fi
