#!/bin/bash

cd $HOME
systemctl stop subspaced-farmer
sleep 120
systemctl stop subspaced
rm -rf /usr/local/bin/*

wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-15/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-nov-15
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-15/subspace-farmer-ubuntu-x86_64-skylake-gemini-3g-2023-nov-15

sudo chmod +x subspace-node subspace-farmer 
sudo mv subspace-node /usr/local/bin/
sudo mv subspace-farmer /usr/local/bin/

sudo systemctl stop subspaced subspaced-farmer &>/dev/null
sudo rm -rf $HOME/.local/share/subspace*

sleep 1

echo "[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/subspace-node --base-path \"$SUBSPACE_NODE_PATH\" --chain gemini-3g --blocks-pruning 256 --state-pruning archive-canonical --no-private-ipv4 --validator --name $SUBSPACE_NODENAME
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/subspaced.service

echo "[Unit]
Description=Subspaced Farm
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/subspace-farmer farm --reward-address $SUBSPACE_WALLET path=$SUBSPACE_FARM_PATH,size=\"$PLOT_SIZE\"
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/subspaced-farmer.service

sudo mv $HOME/subspaced.service /etc/systemd/system/
sudo mv $HOME/subspaced-farmer.service /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced subspaced-farmer
sudo systemctl restart subspaced
sleep 120
sudo systemctl restart subspaced-farmer

echo "==================================================="
echo -e '\n\e[42mChecking node status\e[0m\n' && sleep 1
if [[ `service subspaced status | grep active` =~ "running" ]]; then
  echo -e "Your Subspace node has been \e[32mupdated and running\e[39m!"
  echo -e "You can check node status by issuing the command \e[7mservice subspaced status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Subspace node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
echo "==================================================="
echo -e '\n\e[42mChecking farmer status\e[0m\n' && sleep 1
if [[ `service subspaced-farmer status | grep active` =~ "running" ]]; then
  echo -e "Your Subspace farmer has been \e[32mupgraded and works\e[39m!"
  echo -e "You can check node status by the issung command \e[7mservice subspaced-farmer status\e[0m"
  echo -e "Press \e[7mQ\e[0m to exit from status menu"
else
  echo -e "Your Subspace farmer \e[31mwas not installed correctly\e[39m, please reinstall or restart your farmer service."
  echo -e "Restart your farmer service using command:   systemctl restart subspaced-farmer"
fi
