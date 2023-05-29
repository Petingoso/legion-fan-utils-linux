#!/bin/bash

#NOTE: The values for the gpu tdp in this script are for 3070 MAX-Q
#      You can add cpu/apu option per profile the changing the command in CPU_CONTROL_COMMAD variable and addying the RyzenADJ or Undervolt command (read the readme)

POWER_PROFILE=$(cat /sys/firmware/acpi/platform_profile)
AC_ADAPTER=$(cat /sys/class/power_supply/ADP0/online)
#verfiy Nvidia card is not using vfio
VFIO_LOADED=$(lsmod | grep -w "vfio_pci") #verify vfio
NVIDIA_LOADED=$(lsmod | grep -w "nvidia") #verify nvidia dGPU is loaded
FOLDER=/etc/lenovo-fan-control/profiles # Location of the profiles
#GPU_TDP #value of the gpu tdp in watts
# Fancurve file name (also you can edit FOLDER to edit the location of profiles)

#Pls edit this file for enable GPU TDP
source /etc/lenovo-fan-control/.env

#Disable or Enable the Minicurve

if  [ $AC_ADAPTER == 1 ]; then
    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Profile ﴛ  -> charger..."
        GPU_TDP=80 #set to GPU 80W
        FANCURVE_FILE=$FOLDER/quiet-ac #set the fancurve file
        CPU_CONTROL_COMMAD=$(echo test)

    elif [ $POWER_PROFILE == balanced ]; then
        echo "Applying Balance Mode Profile   -> charger..."
        GPU_TDP=125 #set to GPU 125W
        FANCURVE_FILE=$FOLDER/balanced-ac #set the fancurve file
        CPU_CONTROL_COMMAD=$(echo test)

    elif [ $POWER_PROFILE == performance ]; then
        echo "Applying Performance Mode Profile 龍  -> charger..."
        GPU_TDP=140 #set to GPU 140W
        FANCURVE_FILE=$FOLDER/performance-ac #set the fancurve file
        CPU_CONTROL_COMMAD=$(echo test)
    fi
else
    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Profile ﴛ  -> battery..."
        GPU_TDP=55 #set to GPU 55W
        FANCURVE_FILE=$FOLDER/quiet-bat #set the fancurve file
        CPU_CONTROL_COMMAD=$(echo test)

    elif [ $POWER_PROFILE == balanced ]; then
        echo "Applying Balance Mode Profile   -> battery..."     
        GPU_TDP=65 #set to GPU 65W
        FANCURVE_FILE=$FOLDER/balanced-bat #set the fancurve file
        CPU_CONTROL_COMMAD=$(echo test)
    fi
fi

if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
    nvidia-smi -pl $GPU_TDP
elif [[ $TEAM_RED -eq 1 && $VFIO_LOADED -eq false ]]; then
    rocm-smi --setpoweroverdrive $GPU_TDP
fi

if [[ $CPU_Control -eq 1 ]]; then
    $CPU_CONTROL_COMMAD
fi

python /etc/lenovo-fan-control/lenovo-legion-fan-service.py -i $FANCURVE_FILE
