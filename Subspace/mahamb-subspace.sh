#!/bin/bash
# Code credits goes to the original source. 
# Special thanks to NodeGuru."

exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt update && sudo apt upgrade curl -y < "/dev/null"  
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
sleep 1
sudo apt-get install libgomp1 curl -y < "/dev/null"
sleep 1
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
sleep 1 && curl -s https://raw.githubusercontent.com/mahamb/logo/main/mahamb-logo.sh | bash && sleep 1
read -p "Enter your farmer/reward address: " SUBSPACE_WALLET
echo -e "\e[32mYour wallet address:\e[39m $SUBSPACE_WALLET"
echo "=============================================================================================="
echo ""
echo "Enter your node name to be identified on the network"
read -p "Node name should not contain invalid chars such as '.' and '@'(press enter to use the default: 'MahambNodes'): " SUBSPACE_NODENAME
SUBSPACE_NODENAME=${SUBSPACE_NODENAME:-MahambNodes}
echo -e "\e[32mYour node name:\e[39m $SUBSPACE_NODENAME"
echo "=============================================================================================="
echo ""
read -p "Specify a path for storing farm files (press enter to use the default: `echo $HOME/.local/share/subspace-farmer`): " SUBSPACE_FARM_PATH
SUBSPACE_FARM_PATH=${SUBSPACE_FARM_PATH:-$HOME/.local/share/subspace-farmer}
echo -e "\e[32mYour path for storing farm files\e[39m: $SUBSPACE_FARM_PATH"
echo "=============================================================================================="
echo ""
read -p "Specify a path for storing node files (press enter to use the default: `echo $HOME/.local/share/subspace-node`): " SUBSPACE_NODE_PATH
SUBSPACE_NODE_PATH=${SUBSPACE_NODE_PATH:-$HOME/.local/share/subspace-node}
echo -e "\e[32mYour path for storing node files:\e[39m $SUBSPACE_NODE_PATH"
echo "=============================================================================================="
echo ""
echo "Specify a farm size (defaults to '2.0 GB', press enter to use the default) "
read -p "Example value(don't use quotes) '2.0 GB' '2GB' '2 GB' '2G' '2 G' '2T' '2 T' '2TB' '2 TB': " PLOT_SIZE
PLOT_SIZE=${PLOT_SIZE:-2GB}
echo -e "\e[32mYour plot size is:\e[39m $PLOT_SIZE"
echo "=============================================================================================="
sudo mkdir -p $SUBSPACE_FARM_PATH
sudo mkdir -p $SUBSPACE_NODE_PATH
echo ""
echo -e "\e[32mYour plot size is:\e[39m $PLOT_SIZE"
echo -e "\e[32mYour node name:\e[39m $SUBSPACE_NODENAME"
echo -e "\e[32mYour wallet address:\e[39m $SUBSPACE_WALLET"
echo -e "\e[32mYour path for storing node files:\e[39m $SUBSPACE_NODE_PATH"
echo -e "\e[32mYour path for storing farm files:\e[39m $SUBSPACE_FARM_PATH"
echo ""
sleep 3

sudo apt update && sudo apt install ocl-icd-opencl-dev libopencl-clang-dev libgomp1 -y
cd $HOME
rm -rf subspace-node subspace-farmer
#wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-09/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-nov-09
#wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-09/subspace-farmer-ubuntu-x86_64-skylake-gemini-3g-2023-nov-09
wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-13/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-nov-13
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-3g-2023-nov-13/subspace-farmer-ubuntu-x86_64-skylake-gemini-3g-2023-nov-13
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
echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `service subspaced status | grep active` =~ "running" ]]; then
  echo -e "Your Subspace node has been \e[32minstalled and running\e[39m!"
  echo -e "You can check node status by issuing the command \e[7mservice subspaced status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Subspace node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
echo "==================================================="
echo -e '\n\e[42mCheck farmer status\e[0m\n' && sleep 1
if [[ `service subspaced-farmer status | grep active` =~ "running" ]]; then
  echo -e "Your Subspace farmer has been \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the issung command \e[7mservice subspaced-farmer status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Subspace farmer \e[31mwas not installed correctly\e[39m, please reinstall."
fi
