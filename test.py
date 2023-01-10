import os
from os.path import exists 
import psutil
import fnmatch
import re

class fan_profile:
    fan1_rpm = []
    fan2_rpm = []
    acceleration = []
    deceleration = []
    cpu_min_temp= [] 
    cpu_max_temp= [] 
    gpu_min_temp= [] 
    gpu_max_temp= [] 
    ic_min_temp= [] 
    ic_max_temp= [] 

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

    # Fan1 
    for file in os.listdir(hwmon_dir):
        if fnmatch.fnmatch(file, 'pwm1_auto_point*_pwm'):
            fan_profile.fan1_rpm.append(file)
    # Fan2 
        elif fnmatch.fnmatch(file, 'pwm2_auto_point*_pwm'):
            fan_profile.fan2_rpm.append(file)

    # acceleration 
        elif fnmatch.fnmatch(file, 'pwm1_auto_point*_accel'):
            fan_profile.acceleration.append(file)

    # deceleration 
        elif fnmatch.fnmatch(file, 'pwm1_auto_point*_decel'):
            fan_profile.deceleration.append(file)

    # cpu_min_temp 
        elif fnmatch.fnmatch(file, 'pwm1_auto_point*_temp_hyst'):
            fan_profile.cpu_min_temp.append(file)

    # cpu_max_temp 
        elif fnmatch.fnmatch(file, 'pwm1_auto_point*_temp'):
            fan_profile.cpu_max_temp.append(file)

    # gpu_min_temp 
        elif fnmatch.fnmatch(file, 'pwm2_auto_point*_temp_hyst'):
            fan_profile.gpu_min_temp.append(file)

    # gpu_max_temp 
        elif fnmatch.fnmatch(file, 'pwm2_auto_point*_temp'):
            fan_profile.gpu_max_temp.append(file)

    # ic_min_temp 
        elif fnmatch.fnmatch(file, 'pwm3_auto_point*_temp_hyst'):
            fan_profile.ic_min_temp.append(file)

    # ic_max_temp 
        elif fnmatch.fnmatch(file, 'pwm3_auto_point*_temp'):
            fan_profile.ic_max_temp.append(file)
    
    #fuckthing that sorts pwm_point2_point > pwm_point10_point as normal .sort doenst
    fan_profile.fan1_rpm.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.fan2_rpm.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.acceleration.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.deceleration.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.cpu_min_temp.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.cpu_max_temp.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.gpu_min_temp.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.gpu_max_temp.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.ic_min_temp.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))
    fan_profile.ic_max_temp.sort(key=lambda test_string : list(map(int,re.findall(r'\d+',test_string))))

    #pass filename to value
    map_list(fan_profile.fan1_rpm)
    map_list(fan_profile.fan2_rpm)
    map_list(fan_profile.acceleration)
    map_list(fan_profile.deceleration)
    map_list(fan_profile.cpu_min_temp)
    map_list(fan_profile.cpu_max_temp)
    map_list(fan_profile.gpu_min_temp)
    map_list(fan_profile.gpu_max_temp)
    map_list(fan_profile.ic_min_temp)
    map_list(fan_profile.ic_max_temp)


def store_default():
    if os.path.exists("/home/" + os.getlogin() + "/.deffancurve") != True:
        print("no file")
        print("creating file...")
        deffancurve = open(os.path.expanduser('~')+ "/.deffancurve", "x")
        
        for i in default.fan1_rpm:
            deffancurve.write(i)

    else: 
        print("File already exists")

def store_custom():
    print("placeholder")

def load_profile():
    print("placeholder")

def map_list(list):
    for i in range(len(list)):
         f = open(hwmon_dir + list[i] , "r")
         list[i]=f.read(2048)

find_hwmondir()
parse_config(default)
store_default()
