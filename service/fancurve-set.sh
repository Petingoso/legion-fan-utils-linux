#!/bin/bash

#NOTE: The values for the gpu tdp in this script are for 3070 MAX-Q

POWER_PROFILE=$(cat /sys/firmware/acpi/platform_profile)
AC_ADAPTER=$(cat /sys/class/power_supply/ADP0/online)
#verfiy Nvidia card is not using vfio
NVIDIA_LOADED=$(lsmod | grep -w "nvidia")
FOLDER=/etc/lenovo-fan-control/profiles # Location of the profiles
#GPU_TDP #value of the gpu tdp in watts
# Fancurve file name (also you can edit FOLDER to edit the location of profiles)

#Pls edit this file for enable GPU TDP
source /etc/lenovo-fan-control/.env

if  [ $AC_ADAPTER == 1 ]; then
    if [ $POWER_PROFILE == quiet ]; then
        GPU_TDP=80 #set to GPU 80W
        FANCURVE_FILE=$FOLDER/legion-profile-charger-quiet #set the fancurve file

    elif [ $POWER_PROFILE == balanced ]; then
        GPU_TDP=125 #set to GPU 125W
        FANCURVE_FILE=$FOLDER/legion-profile-charger-balance #set the fancurve file

    elif [ $POWER_PROFILE == performance ]; then
        GPU_TDP=140 #set to GPU 140W
        FANCURVE_FILE=$FOLDER/legion-profile-charger-performance #set the fancurve file
    fi
else
    if [ $POWER_PROFILE == quiet ]; then
        GPU_TDP=55 #set to GPU 55W
        FANCURVE_FILE=$FOLDER/legion-profile-battery-quiet #set the fancurve file

    elif [ $POWER_PROFILE == balanced ]; then
        GPU_TDP=65 #set to GPU 65W
        FANCURVE_FILE=$FOLDER/legion-profile-battery-balance #set the fancurve file
    fi
fi

if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
    ls $FANCURVE_FILE
    python /usr/local/bin/lenovo-legion-fan-service.py -i $FANCURVE_FILE 
    nvidia-smi -pl $GPU_TDP
elif [[ $TEAM_RED -eq 1 ]]; then
    python /usr/local/bin/lenovo-legion-fan-service.py -i $FANCURVE_FILE
else
    python /usr/local/bin/lenovo-legion-fan-service.py -i $FANCURVE_FILE
fi
