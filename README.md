# Fan Curve Manager

[![AUR](https://img.shields.io/aur/version/legion-fan-utils-linux-git?label=aur%20package)](https://aur.archlinux.org/packages/legion-fan-utils-linux-git)
[![Gentoo Overlay](https://img.shields.io/badge/Gentoo--Overlay-mrduarte--ebuilds-blueviolet)](https://github.com/MrDuartePT/mrduarte-ebuilds)

## Overview 
Small script that will apply a given profile.  
Needs [kernel module](https://github.com/johnfanv2/LenovoLegionLinux) to work.  
It'll read a give profile with `sudo python profile_man.py -i $PROFILE`, back up your default config for that mode and change it.

## Features 
- Non permanent, by design. 

- Daemon to chage automatically to the profiles in /etc/lenovo-fan-control/profiles, with updating on mode change and battery events

- Folder location and fancurve files name can be change by editing [/etc/lenovo-fan-control/fancurve.sh](service/fancurve-set.sh)

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

-  Gpu TDP change for AMD and NVIDIA (an be change by editing [/etc/lenovo-fan-control/fancurve.sh](service/fancurve-set.sh))

## Install Systemd Service (optional)

Note: acpid daemon is needed to `systemd service restart` when plugged into AC and the charger is removed.

Change the fan curve files on the repo to your liking and run the install.sh script (DONT RUN WITH SUDO)
Attention: the presence of zero in the balanced and quiet files is because the queit and balance modes only have 9 and 8 fan point respectively, please add zero until they have 10 lines

Location of the fan curves after install: /etc/lenovo-fan-control/

Notes:
- When using this service you need to disable, if you want to, the default behaviour using this command: sudo systemctl disable --now lenovo-fancurve.service lenovo-fancurve-restart.path lenovo-fancurve-restart.service
- Dont use quiet mode on long intensive tasks on both battery and charger.

### Gpu TDP change
***WARNING:ONLY WORKS ON 525 NVIDIA DRIVER; AMD WORKS ON ANY VERSION TO MY KNOWLEDGE***

***WARNING:I DON'T HAVE AN AMD MACHINE, SO PLEASE OPEN AN ISSUE AND REPORT IF IT WORKS***

**Setup**

The TDP change is made using the nvidia-smi for NVIDIA GPUs and [rocm-smi](https://github.com/RadeonOpenCompute/rocm_smi_lib) for AMD GPUs (CPU control will be added in the future).
To enable this feature, edit or create the follwing file
```bash
/etc/lenovo-fan-control/.env
#!/bin/bash

# Remove the comment for your configuration

#RYZEN (Cpu TDP control using RyzenADJ)
#RYZEN_RED=1
#INTEL (Cpu control using undervolt) [https://github.com/georgewhewell/undervolt]
#INTEL_BLUE=1
#NVIDIA (nvidia-smi)
#TEAM_GREEN=1
#AMD (rocm-smi)
#TEAM_RED=1
```

NVIDIA Notes only:
Try to change the nvidia gpu TDP with this command: ```nvidia-smi -pl 140```
If doesn't work run this command and retrying (this command break supergfx funcionality):
```
systemctl enable --now nvidia-persistenced.service
```
Both nvidia and AMD:

If ```/bin/nvidia-smi``` (for nvidia user) or ```/bin/rocm-smi``` (for amd users) doesn't exist, create this sym link:
```bash
# For Nvidia
ln -P /opt/bin/nvidia-smi /bin/nvidia-smi
# For AMD
ln -P /opt/rocm/bin/rocm-smi /bin/rocm-smi
```

For supergfx users I recommend creating this alias on .bashrc or .zshrc:
```bash
alias hybrid_mod="supergfxctl -m hybrid && systemctl start nvidia-persistenced.service"
alias integrated_mode="systemctl stop nvidia-persistenced.service && supergfxctl -m integrated"
```

**Changing Values**
Please get the values of the Base TDP amd MAX TDP for your graphics card:
With these two values you can change a few lines in the file [/etc/lenovo-fan-control/fancurve.sh](service/fancurve-set.sh)

This is a exemple of you can set (3070 values):
 - For quiet you set the base tdp or lower (GPU_TDP=80)
 - For perfomance you set the MAX tdp (GPU_TDP=115 [you can set to 125 if you have a clevo vbios])
 - For balance you can set the base tdp if you set lower in quiet (GPU_TDP=130 [you can set to 140 if you have a clevo vbios])

Roadmap:
 - ADD CPU TDP control (Intel and AMD)
___ 

### Obligatory don't take me to court 
- no warranty, your risk, my project, linux only (why are you here then)


#### Thanks to [the legion fan module](https://github.com/johnfanv2/LenovoLegionLinux) 

#### Thanks for the [systemd service](https://github.com/MrDuartePT/legion-fan-utils-linux)

### Note:
This package and dependency will be updated to the aur for now when using PKGBUILD comment out the dependency and install the module before hand
