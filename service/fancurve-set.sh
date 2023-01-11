#!/bin/bash
POWER_PROFILE=$(cat /sys/firmware/acpi/platform_profile)
FOLDER=$HOME/.config/lenovo-fan-control

if  acpi -a | grep -q on-line; then

    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Fan Curve ﴛ  -> ..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/quiet-charger.profile


    elif [ $POWER_PROFILE == balanced ]; then
        echo "Applying Balance Mode Fan Curve   -> ..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/balance-charger.profile

    else
        echo "Applying Performance Mode Fan Curve 龍  -> ..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/perfomance-charger.profile
    
    fi

else
    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Fan Curve ﴛ  -> ..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/quiet-battery.profile

    else
        echo "Applying Balance Mode Fan Curve   -> ..." 
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/balanced-battery.profile

    fi
fi
