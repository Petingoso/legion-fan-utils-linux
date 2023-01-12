#!/bin/bash
POWER_PROFILE=$(cat /sys/firmware/acpi/platform_profile)
AC_ADAPTER=$(cat /sys/class/power_supply/ADP0/online)
FOLDER=/etc/lenovo-fan-control/profiles

if  [ $AC_ADAPTER == 1 ]; then

    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Fan Curve ﴛ  -> charger..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-charger-quiet


    elif [ $POWER_PROFILE == balanced ]; then
        echo "Applying Balance Mode Fan Curve   -> charger..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-charger-balance

    else
        echo "Applying Performance Mode Fan Curve 龍  -> charger..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-charger-performance 
    
    fi

else
    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Fan Curve ﴛ  -> battery..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-battery-quiet

    else
        echo "Applying Balance Mode Fan Curve   -> battery..." 
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-battery-balanced

    fi
fi
