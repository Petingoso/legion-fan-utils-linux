#!/bin/zsh

USER=$(whoami)

rm -r /home/$USER/.config/lenovo-fan-control

if ! type "$foobar_doas" > /dev/null; then
  Sudo=doas
else 
  Sudo=sudo
fi

$Sudo systemctl disable --now lenovo-fancurve.service lenovo-fancurve-restart.path lenovo-fancurve-restart.service
$Sudo rm /etc/systemd/system/lenovo-fancurve.service /etc/systemd/system/lenovo-fancurve-restart.path /etc/systemd/system/lenovo-fancurve-restart.service
$Sudo systemctl daemon-reload
$Sudo su -c 'rm /usr/local/bin/lenovo-legion-fan-service.py'