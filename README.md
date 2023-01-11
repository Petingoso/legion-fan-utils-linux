# Fan Curver Manager

## Overview 
Small script that will apply a given profile.  
Needs [kernel module](https://github.com/johnfanv2/LenovoLegionLinux) to work.  
It'll read a give profile with `sudo python profile_man.py -i $PROFILE`, back up your default config for that mode and change it.


## Features 
- Non permanent, by design. there's a daemon in works, so TOUPDATE 

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


___ 

### Obligatory don't take me to court 
- no warranty, your risk, my project, linux only (why are you here then)


#### Thanks to [the legion fan module](https://github.com/johnfanv2/LenovoLegionLinux) 
