#!/bin/zsh

USER=$(whoami)

mkdir /home/$USER/.config/lenovo-fan-control

#fix service and python file
sed -i "s/user_name/$USER/g" "service/lenovo-fancurve.service"

cp service/*.profile /home/$USER/.config/lenovo-fan-control/
cp service/*.sh /home/$USER/.config/lenovo-fan-control/
chmod +x profile_man.py

if ! type "$foobar_doas" > /dev/null; then
  Sudo=doas
else 
  Sudo=sudo
fi
$Sudo su -c 'cp service/lenovo-legion-fan-service.py /usr/local/bin/lenovo-legion-fan-service.py'
$Sudo cp service/*.service /etc/systemd/system
$Sudo cp service/*.path /etc/systemd/system
$Sudo systemctl daemon-reload
$Sudo systemctl enable --now lenovo-fancurve.service 
$Sudo systemctl enable --now lenovo-fancurve-restart.path lenovo-fancurve-restart.service

#repair install script after install
sed -i "s/$USER/user_name/g" "service/lenovo-fancurve.service"