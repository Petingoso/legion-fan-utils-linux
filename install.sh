#!/bin/zsh

USER=$(whoami)

mkdir /home/$USER/.config/lenovo-fan-control

sed -i "s/user_name/$USER/g" "lenovo-fancurve.service"

cp servuce/*.profile /home/$USER/.config/lenovo-fan-control/
cp servuce/*.sh /home/$USER/.config/lenovo-fan-control/

if ! type "$foobar_doas" > /dev/null; then
  Sudo=doas
else 
  Sudo=sudo
fi

$Sudo chown root:root profile_man.py
$Sudo chmod 777 profile_man.py
$Sudo cp profile_man.py /usr/bin/lenovo_fan_profile.py
$Sudo cp servuce/*.service /etc/systemd/system
$Sudo cp servuce/*.path /etc/systemd/system
$Sudo systemctl daemon-reload
$Sudo systemctl enable --now lenovo-fancurve.service lenovo-fancurve-restart.path lenovo-fancurve-restart.service

#repair install script after install
sed -i "s/$USER/user_name/g" "lenovo-fancurve.service"