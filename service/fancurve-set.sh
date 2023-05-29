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
if [ $MINICURVE == 0 ]; then
	echo 0 > /sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/hwmon/hwmon*/minifancurve
else 
	echo 1 > /sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/hwmon/hwmon*/minifancurve
fi

if  [ $AC_ADAPTER == 1 ]; then
    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Profile ﴛ  -> charger..."
        GPU_TDP=80 #set to GPU 80W
        FANCURVE_FILE=$FOLDER/legion-profile-charger-quiet #set the fancurve file
        if [ $CPU_Control == 1 ]; then
            CPU_CONTROL_COMMAD= echo test quiet
        fi

    elif [ $POWER_PROFILE == balanced ]; then
        echo "Applying Balance Mode Profile   -> charger..."
        GPU_TDP=125 #set to GPU 125W
        FANCURVE_FILE=$FOLDER/legion-profile-charger-balance #set the fancurve file
        if [ $CPU_Control == 1 ]; then
            CPU_CONTROL_COMMAD= echo test balance
        fi

    elif [ $POWER_PROFILE == performance ]; then
        echo "Applying Performance Mode Profile 龍  -> charger..."
        GPU_TDP=140 #set to GPU 140W
        FANCURVE_FILE=$FOLDER/legion-profile-charger-performance #set the fancurve file
        if [ $CPU_Control == 1 ]; then
            CPU_CONTROL_COMMAD= echo test performance
        fi
    fi
else
    if [ $POWER_PROFILE == quiet ]; then
        echo "Applying Quiet Mode Profile ﴛ  -> battery..."
        GPU_TDP=55 #set to GPU 55W
        FANCURVE_FILE=$FOLDER/legion-profile-battery-quiet #set the fancurve file
        if [ $CPU_Control == 1 ]; then
            CPU_CONTROL_COMMAD= echo test quiet
        fi

    elif [ $POWER_PROFILE == balanced ]; then
        echo "Applying Balance Mode Profile   -> battery..."     
        GPU_TDP=65 #set to GPU 65W
        FANCURVE_FILE=$FOLDER/legion-profile-battery-balance #set the fancurve file
        if [ $CPU_Control == 1 ]; then
            CPU_CONTROL_COMMAD= echo test balanced
        fi
    fi
fi

if [[ $TEAM_GREEN -eq 1 && $NVIDIA_LOADED ]]; then
    nvidia-smi -pl $GPU_TDP
elif [[ $TEAM_RED -eq 1 && $VFIO_LOADED -eq false ]]; then
    rocm-smi --setpoweroverdrive $GPU_TDP
fi

python /etc/lenovo-fan-control/lenovo-legion-fan-service.py -i $FANCURVE_FILE
