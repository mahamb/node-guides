## Subspace Official documentation:
>- https://docs.subspace.network/docs/intro

## Recommended Operator Hardware Requirements 
# CPU:
>- x86-64 compatible;
>- Intel Ice Lake, or newer (Xeon or Core series); AMD Zen3, or newer (EPYC or Ryzen);
>- 4 physical cores @ 3.4GHz;
>- Simultaneous multithreading disabled (Hyper-Threading on Intel, SMT on AMD);
Prefer single-threaded performance over higher cores count. A comparison of single-threaded performance can be found here.

# Storage:
>- An NVMe SSD of 1 TB. In general, the latency is more important than the throughput.

# Memory:
>- 32 GB DDR4 ECC.

# System:
>- Linux Kernel 5.16 or newer.

# Network:
>- The minimum symmetric networking speed is set to 500 Mbit/s.

# Installation
>- If you don’t have a subspace wallet yet, go to [Subspace Wallet](https://docs.subspace.network/docs/category/wallets) to create a wallet first, then proceed with the installation."
>- Use below script for quick installation, for processors since 2015."

```
wget -O mahamb-subspace.sh https://raw.githubusercontent.com/mahamb/node-guides/main/Subspace/mahamb-subspace.sh && chmod +x mahamb-subspace.sh && ./mahamb-subspace.sh
```

# Additional Useful System Commands
>- Check node logs:

```
journalctl -u subspaced -f -o cat
```

>- Check farmer logs:

```
journalctl -u subspaced-farmer -f -o cat
```
>- Restart node:
```
sudo systemctl restart subspaced
```
>- Restart farmer:
```
sudo systemctl restart subspaced-farmer
```
>- Delete node:
```
sudo systemctl stop subspaced subspaced-farmer
sudo systemctl disable subspaced subspaced-farmer
sudo rm -rf ~/.local/share/subspace*
sudo rm -rf /etc/systemd/system/subspace*
sudo rm -rf /usr/local/bin/subspace*
```
