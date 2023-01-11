#!/bin/bash


rm -r $HOME/.config/lenovo-fan-control

if ! type "$foobar_doas" > /dev/null; then
  sudo=doas
else 
  sudo=sudo
fi

$sudo systemctl disable --now lenovo-fancurve.service lenovo-fancurve-restart.path lenovo-fancurve-restart.service
$sudo rm /etc/systemd/system/lenovo-fancurve.service /etc/systemd/system/lenovo-fancurve-restart.path /etc/systemd/system/lenovo-fancurve-restart.service
$sudo systemctl daemon-reload
$sudo su -c 'rm /usr/local/bin/lenovo-legion-fan-service.py'
