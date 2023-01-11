#!/bin/bash
POWER_PROFILE=$(cat /sys/firmware/acpi/platform_profile)
HOME_USER=/home/mrduarte

if  acpi -a | grep -q on-line; then

    if [ $POWER_PROFILE == quiet ]; then
        exec lenovo_fan_profile.py -i $HOME_USER/.config/lenovo-fan-control/quiet-charger.sh


    elif [ $POWER_PROFILE == balanced ]; then
        exec lenovo_fan_profile.py -i $HOME_USER/.config/lenovo-fan-control/balance-charger.sh

    else 
        exec lenovo_fan_profile.py -i $HOME_USER/.config/lenovo-fan-control/performance-charger.sh
    
    fi

else
    if [ $POWER_PROFILE == quiet ]; then
        exec lenovo_fan_profile.py -i $HOME_USER/.config/lenovo-fan-control/quiet-battery.sh

    else 
        exec lenovo_fan_profile.py -i $HOME_USER/.config/lenovo-fan-control/balance-battery.sh

    fi

    #elif [ $POWER_PROFILE == balanced ]; then
    #    exec $HOME/.config/lenovo-fan-control/balanced-battery.sh

    #i dont what perfomance on battery
    #else 
    #    exec $HOME/.config/lenovo-fan-control/performance-battery.sh
fi