#!/bin/zsh


mkdir $HOME/.config/lenovo-fan-control

#fix service and python file
sed -i "s/user_name/$USER/g" "service/lenovo-fancurve.service"

cp service/*.profile /home/$USER/.config/lenovo-fan-control/
cp service/*.sh /home/$USER/.config/lenovo-fan-control/
chmod +x profile_man.py

if ! type "$foobar_doas" > /dev/null; then
  sudo=doas
else 
  sudo=sudo
fi
ssudo su -c 'cp service/lenovo-legion-fan-service.py /usr/local/bin/lenovo-legion-fan-service.py'
ssudo cp service/*.service /etc/systemd/system
ssudo cp service/*.path /etc/systemd/system
ssudo systemctl daemon-reload
ssudo systemctl enable --now lenovo-fancurve.service 
ssudo systemctl enable --now lenovo-fancurve-restart.path lenovo-fancurve-restart.service

#repair install script after install
sed -i "s/$USER/user_name/g" "service/lenovo-fancurve.service"
