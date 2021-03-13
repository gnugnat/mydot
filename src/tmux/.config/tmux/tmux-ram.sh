#!/bin/sh


# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the ISC License


memory="$(vmstat -s | grep 'free memory' | awk -F ' ' '{print $1}')"

# > 1024^2
gbs=$((memory / 1048576))
# > 1024
mbs=$((memory / 1024))
# < 1024
kbs=$((memory))


if [ "${memory}" != "" ]
then
    if [ "${gbs}" != 0 ]
    then
        printf "%sG" ${gbs}
    elif [ "${mbs}" != 0 ]
    then
        printf "%sM" ${mbs}
    elif [ "${kbs}" != 0 ]
    then
        printf "%sK" ${kbs}
    fi
fi
