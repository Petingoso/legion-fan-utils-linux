# Fan Curve Manager

## Overview 
Small script that will apply a given profile.  
Needs [kernel module](https://github.com/johnfanv2/LenovoLegionLinux) to work.  
It'll read a give profile with `sudo python profile_man.py -i $PROFILE`, back up your default config for that mode and change it.


## Features 
- Non permanent, by design. 

- Daemon to chage automatically to the profiles in /etc/lenovo-fan-control/profiles, with updating on mode change and battery events 

- Expandable and scriptable, with tiny adjustments you can load easily, such as backing up all profile modes or tweaking to only parse.  

- Supports custom profiles on the following format:
```bash
#PROP NAME (acc/decelaration,fan1/2rpm,gpu/cpu/ic max/min temp)
1 #value for point 1,...
2 
3 
4 
5 
6 
7 
8 
9
0 #last point is performance mode only, so value only matters in that mode
```
- should be compatible with all models of the kernel module

-  janky, as such, please sanitize your input

-  Gpu TDP change (systemd service) *[for now only Nvidia supported for AMD I need someone with all AMD legion]*

## Install Systemd Service (optional)

Change the fan curve files on the repo to your liking and run the install.sh script (DONT RUN WITH SUDO)
Attencion: the presence of zero in the balanced and quiet files is because the queit and balance mode only have 9 and 8 fan point respectively please add zero ultil have 10 lines

Location of the fan curves after install: /etc/lenovo-fan-control/

Notes:
- When using this service you need to disable if you what the default behaviour using this command: sudo systemctl disable --now lenovo-fancurve.service lenovo-fancurve-restart.path lenovo-fancurve-restart.service
- Dont use quiet mode on long intensive task on both battery and charger

### Gpu TDP change
The TDP change is made using the nvidia-smi and ths env variable need to be set, the valuabes set in the fancurve.sh script is for 3070 laptop if you have a different you need to find two valubles one is the base TDP and Max TDP (the Max TDP is value your gpu can go with dynamic boost [nvidia-powerd service])

For some driver version you need to run this as root:
```bash
systemctl enable --now nvidia-persistenced.service
```
Note if the script get error "nvidia-smi dont exist" create symbolink with this command:
```bash
ln -P /opt/bin/nvidia-smi /bin/nvidia-smi
```

We this two value you can change few lines in the [fancurve.sh script](service/fancurve-set.sh)

This is a exemple of you can set (3070 values):
 - For quiet you set the base tdp or lower (nvidia-smi -pl 80)
 - For perfomance you set the MAX tdp (nvidia-smi -pl 115 [you can set to 125 if you have a clevo vbios])
 - For balance you can set the base tdp if you set lower in quiet (nvidia-smi -pl 130 [you can set to 140 if you have a clevo vbios])

NOTES: ONLY WORK ON 525 NVIDIA DRIVER

Roadmap:
 - Thinking of adding CPU TDP control (Intel and AMD)
 - If you whant a AMD support create a issue i need some help and tester
___ 

### Obligatory don't take me to court 
- no warranty, your risk, my project, linux only (why are you here then)


#### Thanks to [the legion fan module](https://github.com/johnfanv2/LenovoLegionLinux) 

#### Thanks for the [systemd service](https://github.com/MrDuartePT/legion-fan-utils-linux)

### Note:
This package and dependency will be updated to the aur for now when using PKGBUILD comment out the dependency and install the module before hand
