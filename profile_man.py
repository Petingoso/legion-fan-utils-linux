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

default = fan_profile()

hwmon_dir = ""

def find_hwmondir():
    global hwmon_dir

    for file in os.listdir("/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/hwmon/"):

        if "hwmon" in file:
            hwmon_dir = "/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/hwmon/" + file + "/"
            print("found dir at ", hwmon_dir)
        else:
            print("tough luck, is the module loaded*")


def parse_config(fan_profile):
    #fan1
    for i in range(1,10):
        file="pwm1_auto_point{}_pwm".format(i)
        fan_profile.fan1_rpm.append(valueof(file))

    #fan2
    for i in range(1,10):
        file="pwm2_auto_point{}_pwm".format(i)
        fan_profile.fan2_rpm.append(valueof(file))

    #cpu_min_temp
    for i in range(1,10):
        file="pwm1_auto_point{}_temp_hyst".format(i)
        fan_profile.cpu_min_temp.append(valueof(file))

    #cpu_max_temp
    for i in range(1,10):
        file="pwm1_auto_point{}_temp".format(i)
        fan_profile.cpu_max_temp.append(valueof(file))

    #gpu_min_temp
    for i in range(1,10):
        file="pwm2_auto_point{}_temp_hyst".format(i)
        fan_profile.gpu_min_temp.append(valueof(file))

    #gpu_max_temp
    for i in range(1,10):
        file="pwm2_auto_point{}_temp".format(i)
        fan_profile.gpu_max_temp.append(valueof(file))

    #ic_min_temp
    for i in range(1,10):
        file="pwm3_auto_point{}_temp_hyst".format(i)
        fan_profile.ic_min_temp.append(valueof(file))

    #ic_max_temp
    for i in range(1,10):
        file="pwm3_auto_point{}_temp".format(i)
        fan_profile.ic_max_temp.append(valueof(file))

    #acceleration
    for i in range(1,10):
        file="pwm1_auto_point{}_accel".format(i)
        fan_profile.acceleration.append(valueof(file))

    #deceleration
    for i in range(1,10):
        file="pwm1_auto_point{}_decel".format(i)
        fan_profile.deceleration.append(valueof(file))


def store_profile(profile):
    if os.path.exists("/home/" + os.getlogin() + "/.{}".format(profile)) != True:
        print("no file")
        print("creating file...")
        deffancurve = open(os.path.expanduser('~')+ "/.{}".format(profile), "x")

        tmplist=[]
        for list in dir(profile):
            if not list.startswith('__'):

                tmplist = getattr(profile,list)
                deffancurve.write("#{}\n".format(list))

                for element in tmplist:
                    deffancurve.write(element)
    else: 
        print("File already exists")

def store_defaults():
    print("placeholder")

def load_profile():
    print("placeholder")

def valueof(file):
    f = open(hwmon_dir + file, "r")
    value = f.read(2048)
    return value

find_hwmondir()
parse_config(default)
store_profile(default)

