#!/bin/bash

#NOTE: The values for the gpu tdp in this script are for 3070 MAX-Q

POWER_PROFILE=$(cat /sys/firmware/acpi/platform_profile)
AC_ADAPTER=$(cat /sys/class/power_supply/ADP0/online)
FOLDER=/etc/lenovo-fan-control/profiles
KERNEL=$(uname -r)
#verfiy Nvidia card is not using vfio
NVIDIA_LOADED=$(lsmod | grep -w "nvidia")

#Verify NVIDIA and AMD
  if [[ $(ls /lib/modules/$KERNEL/video/nvidia.ko) ]]; then
    TEAM_GREEN=1
  else
    TEAM_RED=1  
  fi

if  [ $AC_ADAPTER == 1 ]; then

    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Profile ﴛ  -> charger..."
        #Before fan curve to avoid failling to apply
        #TDP in quiet
        if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
            exec nvidia-smi -pl 80 # set to 80W
        elif [[ $TEAM_RED -eq 1 ]]; then
            echo "Need help for AMD :( open a issue"
        fi

        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-charger-quiet


    elif [ $POWER_PROFILE == balanced ]; then
        echo "Applying Balance Mode Profile   -> charger..."

        #Before fan curve to avoid failling to apply
        #TDP in balanced
        if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
            exec nvidia-smi -pl 125 # set to 125W
        elif [[ $TEAM_RED -eq 1 ]]; then
            echo "Need help for AMD :( open a issue"
        fi

        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-charger-balance

    else
        echo "Applying Performance Mode Profile 龍  -> charger..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-charger-performance

        #Before fan curve to avoid failling to apply
        #TDP in performance
        if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
            exec nvidia-smi -pl 125 # set to 125W
        elif [[ $TEAM_RED -eq 1 ]]; then
            echo "Need help for AMD :( open a issue"
        fi
    
    fi

else
    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Profile ﴛ  -> battery..."
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-battery-quiet

        #Before fan curve to avoid failling to apply
        #TDP in quiet
        if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
            exec nvidia-smi -pl 80 # set to 80W
        elif [[ $TEAM_RED -eq 1 ]]; then
            echo "Need help for AMD :( open a issue"
        fi

    else
        echo "Applying Balance Mode Profile   -> battery..." 
        exec python /usr/local/bin/lenovo-legion-fan-service.py -i $FOLDER/legion-profile-battery-balanced
        
        #Before fan curve to avoid failling to apply
        #TDP in quiet
        if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
            exec nvidia-smi -pl 100 # set to 100W
        elif [[ $TEAM_RED -eq 1 ]]; then
            echo "Need help for AMD :( open a issue"
        fi
    fi
fi
