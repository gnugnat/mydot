#!/bin/sh

totalseconds=$(cat /proc/uptime | awk -F . '{print $1}')

seconds=$(($totalseconds % 60))
minutes=$((($totalseconds / 60) % 60))
hours=$((($totalseconds / 3600) % 24))
days=$(($totalseconds / 86400))

if [ $days != 0 ]; then printf $days\d,\ ; fi
if [ $hours != 0 ]; then printf $hours\h,\ ; fi
if [ $minutes != 0 ]; then printf $minutes\m; else printf $seconds\s; fi
