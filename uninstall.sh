#!/bin/bash



if ! type "$foobar_doas" > /dev/null; then
  sudo=doas
else 
  sudo=sudo
fi

$sudo rm -r /etc/lenovo-fan-control
$sudo systemctl disable --now lenovo-fancurve.service lenovo-fancurve-restart.path lenovo-fancurve-restart.service
$sudo rm /etc/systemd/system/lenovo-fancurve.service /etc/systemd/system/lenovo-fancurve-restart.path /etc/systemd/system/lenovo-fancurve-restart.service
$sudo systemctl daemon-reload
$sudo rm /usr/local/bin/lenovo-legion-fan-service.py /usr/local/bin/lenovo-legion-manager.py
