#!/bin/sh


batteries=/sys/class/power_supply


for b in "${batteries}"/*
do
    battery=$(basename "${b}")
    if [ -e "/sys/class/power_supply/${battery}/energy_full" ]; then

	    energy_full="$(cat "/sys/class/power_supply/${battery}/energy_full")"
	    energy_now="$(cat "/sys/class/power_supply/${battery}/energy_now")"

	    percentage=$((energy_now * 100 / energy_full))

	    if [ ${percentage} -gt 60 ]
        then
	        printf "#[fg=#00ff00]"
	    elif [ ${percentage} -lt 15 ]
        then
	        printf "#[fg=#ff0000]"
	    else
	        printf "#[fg=#ffff00]"
	    fi

	    printf "${percentage}%% "
    fi
done
