# Avail Validator Installation Guide (Using Binaries)
Avail is a highly robust modular base layer that is laser-focused on data availability: ordering, publishing transactions, and making it possible to seamlessly verify the availability of block data.

**NOTE:** This guide is based on Avail Node version **v1.8.0.0**.
      I will try my best to keep this guide updated with Avail Node version.

# Official documentation is available here:
>- https://docs.availproject.org/
>- https://docs.availproject.org/category/operate-a-node/
>- https://docs.availproject.org/category/new-user-guide/
>- https://github.com/availproject/avail

# Submit your interest application form for Validator Node: 
>- https://docs.google.com/forms/d/e/1FAIpQLScvgXjSUmwPpUxf1s-MR2C2o5V79TSoud1dLPKVgeLiLFuyGQ/viewform

# Minimum Hardware Requirements 
>- 4GB RAM
>- 2core CPU (amd64/x86 architecture)
>- 20-40 GB Storage (SSD)

# Recommended Hardware Requirements 
>- 8GB RAM
>- 4core CPU (amd64/x86 architecture)
>- 200-300 GB Storage (SSD)
```diff
- While Avail is currently in its testnet phase, running validator nodes requires significant system administration expertise.
```
| Network | Version | Current | Last modified |
|---------------|-------------|-------------|-------------|
| **Kate Testnet** | v1.7.2 | No |  |
| **Goldberg Testnet** | v1.8.0.0 | Yes | 2023/11/08 |
```
Ports used: 30333
```
## SETUP (AVAIL NODE  INSTALLATION)
### Option 1 (automatic install using script)
You can setup your avail validator in few minutes by using automated script below.
Set any validator name of your choice.
```
_In Progress... Please stay tuned._
```

### Option 2 (Manual Installation)
## Setup Variables
```
cd $HOME
```
Here you have to put name of your node name (validator) that will be visible in explorer
```
NODENAME=<YOUR_NODE_NAME_GOES_HERE>
```
Save and import variables into system
```
AVAIL_PORT=30333
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export AVAIL_PORT=${AVAIL_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Update OS System packages
```
sudo apt update && sudo apt upgrade -y
```
## Install Screen
sudo apt-get install screen -y
screen --version

## Install Avail Node Pakacge dependencies
```
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
## Install Rust Software
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
```

**Use ``screen -S`` to open a separate terminal instance**
screen -S AvailNode

## Download and build binaries
```
git clone https://github.com/availproject/avail.git
cd avail
mkdir -p data
git checkout v1.8.0.0
cargo build --release -p data-avail
sudo cp $HOME/avail/target/release/data-avail /usr/local/bin
```
## Create Systemd Service
## ***Moniker is your validator name***
```
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network-online.target

[Service]
User=$USER
ExecStart=$(which data-avail) -d `pwd`/data --chain goldberg --validator --name $NODENAME
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
## Register and start service
```
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable availd
sudo systemctl restart availd && sudo journalctl -u availd -f -o cat
```
***Now your node is running in screen press "Ctrl+a+d" while running your node and left the screen.***
***Use ``screen -r`` to return back to AVAIL screen***

### Before you can become an active validator, you need to bond your funds to your node. 
>- Stake your validator: https://docs.availproject.org/operate/validator/staking

# Explorer:
>- https://telemetry.avail.tools
>- https://goldberg.avail.tools

# LeaderBoard:
>- https://leaderboard.availproject.org
