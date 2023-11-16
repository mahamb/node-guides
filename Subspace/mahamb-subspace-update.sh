#!/bin/bash
sleep 1 && curl -s https://raw.githubusercontent.com/mahamb/logo/main/mahamb-logo.sh | bash && sleep 3
echo "==================================================="
echo -e '\n\e[42mStopping Subspace Farmer Service....\e[0m\n' && sleep 1
cd $HOME
systemctl stop subspaced-farmer
echo -e '\n\e[42mStopping Subspace Node Service....\e[0m\n' && sleep 1
sleep 120
systemctl stop subspaced

echo -e '\n\e[42mDeleting the old subspace bin files....\e[0m\n' && sleep 1
rm -rf /usr/local/bin/*

echo -e '\n\e[42mDownloading the loading subspace bin files....\e[0m\n' && sleep 1
wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-15/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-nov-15
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-15/subspace-farmer-ubuntu-x86_64-skylake-gemini-3g-2023-nov-15

sudo chmod +x subspace-node subspace-farmer 
sudo mv subspace-node /usr/local/bin/
sudo mv subspace-farmer /usr/local/bin/

sleep 5

echo -e '\n\e[42mStarting the Subspace....\e[0m\n' && sleep 3
systemctl start subspaced
sleep 120
systemctl start subspaced-farmer

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
