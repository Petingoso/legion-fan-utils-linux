#!/bin/bash

if ! type "$foobar_doas" > /dev/null; then
  sudo=doas
else 
  sudo=sudo
fi

$sudo mkdir -p /etc/lenovo-fan-control/profiles

$sudo cp service/profiles/* /etc/lenovo-fan-control/profiles
$sudo cp service/fancurve-set.sh /etc/lenovo-fan-control
$sudo cp service/lenovo-legion-fan-service.py /usr/local/bin/lenovo-legion-fan-service.py
$sudo cp profile_man.py /usr/local/bin/lenovo-legion-manager.py
$sudo cp service/*.service /etc/systemd/system
$sudo cp service/*.path /etc/systemd/system
$sudo systemctl daemon-reload
$sudo systemctl enable --now lenovo-fancurve.service 
$sudo systemctl enable --now lenovo-fancurve-restart.path lenovo-fancurve-restart.service

