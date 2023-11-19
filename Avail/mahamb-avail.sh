#!/bin/bash
exists()
{
	  command -v "$1" >/dev/null 2>&1
  }
if exists curl; then
	echo ''
else
	  sudo apt update && sudo apt upgrade -y < "/dev/null" 
	  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
	    . $HOME/.bash_profile
fi

sleep 1 && curl -s https://raw.githubusercontent.com/mahamb/logo/main/mahamb-logo.sh | bash && sleep 2
echo -e "\e[1m\e[32mChecking if default Avail port is running. Installation will exit if port 30333 is in use. \e[0m" && sleep 2
if ss -tulpen | awk '{print $5}' | grep -q ":30333$" ; then
        echo -e "\e[31mInstallation is not possible, port 30333 already in use.\e[39m"
sleep 5
     exit
sleep 5
else
     echo ""
fi

# set vars
AVAIL_PORT=30333
if [ ! $NODENAME ]; then
	read -p "Enter Your Avail Node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
source $HOME/.bash_profile
echo "export AVAIL_PORT=${AVAIL_PORT}" >> $HOME/.bash_profile
echo ""
echo '================================================='
echo -e "Enter your Avail Node name: \e[1m\e[32m$NODENAME\e[0m"
echo "================================================="
echo ""
echo -e "Enter your Avail Service Port: \e[1m\e[32m$AVAIL_PORT\e[0m"
echo '================================================='
sleep 3

echo -e "\e[1m\e[32m1. Updating OS System packages... \e[0m" && sleep 3
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing Avail package dependencies... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

echo -e "\e[1m\e[32m1. Installing RUST package... \e[0m" && sleep 1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
sleep 1

echo -e "\e[1m\e[32m3. Downloading and Building binaries... \e[0m" && sleep 1

git clone https://github.com/availproject/avail.git
cd avail
mkdir -p data
git checkout v1.8.0.2
cargo build --release -p data-avail
. $HOME/.bash_profile
sudo cp $HOME/avail/target/release/data-avail /usr/local/bin

echo -e "\e[1m\e[32m3. Creating SystemD files... \e[0m" && sleep 1
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network-online.target

[Service]
User=$USER
ExecStart=$(which data-avail) -d /root/avail/data --chain goldberg --validator --name $NODENAME
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

echo -e "\e[1m\e[32m4. Re-initializing Systemd... \e[0m" && sleep 1
sudo systemctl daemon-reload

echo -e "\e[1m\e[32m4. Starting Availd service... \e[0m" && sleep 1
sudo systemctl enable availd
sudo systemctl restart availd

echo "==================================================="
echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `systemctl status availd | grep active` =~ "running" ]]; then
  echo -e "Your Availd node has been \e[32minstalled and working\e[39m!"
  echo -e "You can check node status by the command \e[7msystemctl status availd\e[0m"
  echo -e 'View the logs from the running service:: journalctl -f -u availd.service'
  echo -e "Check the node is running: sudo systemctl status availd.service"
  echo -e "Stop your avail node: sudo systemctl stop availd.service"
  echo -e "Start your avail node: sudo systemctl start availd.service"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Avail node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
