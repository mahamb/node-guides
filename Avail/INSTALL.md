# Avail Full Node Installation Guide (Using Binaries)
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

# Recommended Operating System 
>- Ubuntu 22.04

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

**Avail Node Port: 30333**

## SETUP (AVAIL NODE  INSTALLATION)
### OPTION 1: Automatic install using bash script
You can setup your avail validator in few minutes by using automated script below.
Set any validator name of your choice.
```
In Progress... Please stay tuned.
```

### OPTION 2: Manual Installation (If you want to see how Avail is installed in detail.)
## Setup Enrironment Variables
```
cd $HOME
```
Replace with your node name (validator) that will be visible in Avail explorers.
>- NODENAME=<YOUR_NODE_NAME_GOES_HERE>

>- Save and import variables into system
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
## Install Screen Package
```
sudo apt-get install screen -y
screen --version
```
## Install Avail Node Package dependencies
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

## Open a separate terminal instance using screen
```
screen -S AvailNode
```
## Download and build binaries
```
git clone https://github.com/availproject/avail.git
cd avail
mkdir -p data
git checkout v1.8.0.0
cargo build --release -p data-avail
sudo cp $HOME/avail/target/release/data-avail /usr/local/bin
```
Wait for the downloading and compiling of packages to be completed
![ alt text](https://github.com/mahamb/node-guides/blob/main/Avail/cargo_run.png)

## Create Systemd Service (Autostart during bootup)
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
## Register and Start Availd Service in SystemD
```
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable availd
sudo systemctl restart availd && sudo journalctl -u availd -f -o cat
```
You should see similar logs like below:
![ alt text](https://github.com/mahamb/node-guides/blob/main/Avail/avail_status_logs.png)

**Now your node is running in separate screen terminal. Press "Ctrl+a+d" while running your node and left the screen.
Use ``screen -r`` to return back to AVAIL screen.**

## Becoming an Active Validator
>- To become an active validator, you need to bond funds (AVL tokens) into your node. You can request from goldberg faucet channel _https://discord.com/channels/1065831819154563132/1171414018028740698_.
You can request **every 3 hours** using the same wallet address and a **maximum of 100** AVL tokens every 13 days.
But for now, the team will select and send the 1000 Avail tokens need to bond into your node so you can initialize your node as Validator.
>- Staking AVL tokens to your validator node: https://docs.availproject.org/operate/validator/staking

## Avail Explorers:
>- https://telemetry.avail.tools
>- https://goldberg.avail.tools

## Avail LeaderBoard:
>- https://leaderboard.availproject.org

## Security (Allow port 3033)
```
ufw allow 3033
```
