import os
from os.path import exists 
import psutil
import fnmatch
import re

class fan_profile:
    fan1_rpm = []
    fan2_rpm = []
    cpu_min_temp= [] 
    cpu_max_temp= [] 
    gpu_min_temp= [] 
    gpu_max_temp= [] 
    ic_min_temp= [] 
    ic_max_temp= [] 
    acceleration = []
    deceleration = []

hwmon_dir = ""

def find_hwmondir():
    global hwmon_dir 
    if os.path.exists("/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/hwmon/") == True:
        for file in os.listdir("/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/hwmon/"):

            if "hwmon" in file:
                hwmon_dir = "/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/hwmon/" + file + "/"
                print("found hwmon dir at", hwmon_dir)
            else:
                print("hwmon directory not found, is the module loaded?")
    else:
        print("Can't find the hwmon path, is everything correct")



def parse_def_config(fan_profile):
    #fan1
    for i in range(1,11):
        file="pwm1_auto_point{}_pwm".format(i)
        fan_profile.fan1_rpm.append(valueof(file))

    #fan2
    for i in range(1,11):
        file="pwm2_auto_point{}_pwm".format(i)
        fan_profile.fan2_rpm.append(valueof(file))

    #cpu_min_temp
    for i in range(1,11):
        file="pwm1_auto_point{}_temp_hyst".format(i)
        fan_profile.cpu_min_temp.append(valueof(file))

    #cpu_max_temp
    for i in range(1,11):
        file="pwm1_auto_point{}_temp".format(i)
        fan_profile.cpu_max_temp.append(valueof(file))

    #gpu_min_temp
    for i in range(1,11):
        file="pwm2_auto_point{}_temp_hyst".format(i)
        fan_profile.gpu_min_temp.append(valueof(file))

    #gpu_max_temp
    for i in range(1,11):
        file="pwm2_auto_point{}_temp".format(i)
        fan_profile.gpu_max_temp.append(valueof(file))

    #ic_min_temp
    for i in range(1,11):
        file="pwm3_auto_point{}_temp_hyst".format(i)
        fan_profile.ic_min_temp.append(valueof(file))

    #ic_max_temp
    for i in range(1,11):
        file="pwm3_auto_point{}_temp".format(i)
        fan_profile.ic_max_temp.append(valueof(file))

    #acceleration
    for i in range(1,11):
        file="pwm1_auto_point{}_accel".format(i)
        fan_profile.acceleration.append(valueof(file))

    #deceleration
    for i in range(1,11):
        file="pwm1_auto_point{}_decel".format(i)
        fan_profile.deceleration.append(valueof(file))

    print("default profile parsed")


def store_profile(profile,name):
    if os.path.exists("/home/" + os.getlogin() + "/.legion-profile-{}".format(name)) != True:
        print("no file")
        print("creating file...")
        deffancurve = open("/home/" + os.getlogin() + "/.legion-profile-{}".format(name), "x")

        tmplist=[]
        for list in dir(profile):
            if not list.startswith('__'):

                tmplist = getattr(profile,list)
                deffancurve.write("#{}\n".format(list))

                for element in tmplist:
                    deffancurve.write(element)
    else: 
        print("File already exists")

def store_default():
    default = fan_profile()
    parse_def_config(default)
    store_profile(default,"default")

def parse_custom_profile(path,profile):
    i=1 
    file=open(path,'r')
    for line in file:
        if line.startswith("#"):
            continue
        else:
            if i<=10:
                profile.acceleration.append(line)
            elif i<=20:
                profile.cpu_max_temp.append(line)
            elif i<=30:
                profile.cpu_min_temp.append(line)
            elif i<=40:
                profile.deceleration.append(line)
            elif i<=50:
                profile.fan1_rpm.append(line)
            elif i<=60:
                profile.fan2_rpm.append(line)
            elif i<=70:
                profile.gpu_max_temp.append(line)
            elif i<=80:
                profile.gpu_min_temp.append(line)
            elif i<=90:
                profile.ic_max_temp.append(line)
            elif i<=100:
                profile.ic_min_temp.append(line)
        i=i+1



def is_default_stored():
    if os.path.exists("/home/" + os.getlogin() + "/.legion-default") != True:
        print("no default lockfile")
        lockfile = open("/home/" + os.getlogin() + "/.legion-default", "x")
        return 0
    else:
        print("defaults already stored")
        return 1

def valueof(file):
    f = open(hwmon_dir + file, "r")
    value = f.read(2048)
    return value

def openabs(file):
    f = open(hwmon_dir + file, "w")
    return f


def apply_profile_default(fan_profile):
    apply_profile(default)

def apply_profile(fan_profile):
    #traverse fan.rpm 
    #write first value to pwm1_auto_point{i}_pwm
    #advance
    i=1

    for element in fan_profile.fan1_rpm:
        file = openabs("pwm1_auto_point{}_pwm".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.fan2_rpm:
        file = openabs("pwm2_auto_point{}_pwm".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.cpu_min_temp:
        file = openabs("pwm1_auto_point{}_temp_hyst".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.cpu_max_temp:
        file = openabs("pwm1_auto_point{}_temp".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.gpu_min_temp:
        file = openabs("pwm2_auto_point{}_temp_hyst".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.gpu_max_temp:
        file = openabs("pwm2_auto_point{}_temp".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.ic_min_temp:
        file = openabs("pwm3_auto_point{}_temp_hyst".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.ic_max_temp:
        file = openabs("pwm3_auto_point{}_temp".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.acceleration:
        file = openabs("pwm1_auto_point{}_accel".format(i))
        file.write(element)
        i=i+1
        file.close()

    i=1

    for element in fan_profile.deceleration:
        file = openabs("pwm1_auto_point{}_decel".format(i))
        file.write(element)
        i=i+1
        file.close()


    print("fan profile applied")



find_hwmondir()
if is_default_stored() == 0:
    parse_def_config()
    store_default()

custom=fan_profile()
parse_custom_profile("/home/petarch/.legion-profile1",custom)
apply_profile(custom)

