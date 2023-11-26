# Updating your Subspace Node to version gemini-3g-2023-nov-21
# For Advance CLI Skylake+ CPU
```
wget -O mahamb-subspace-update.sh https://raw.githubusercontent.com/mahamb/node-guides/main/Subspace/mahamb-subspace-update.sh && chmod +x mahamb-subspace-update.sh && ./mahamb-subspace-update.sh
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

## Disclaimer:
The information provided in this Subspace Full Node Installation guide is intended for educational and informational purposes only. While every effort has been made to ensure the accuracy and reliability of the content, the author and contributors assume no responsibility for errors or omissions.
Users are encouraged to exercise caution and discretion while following the instructions outlined in this guide. It is important to verify commands and configurations in a non-production environment before applying them to critical systems.
The author and contributors shall not be held liable for any damages, losses, or issues arising from the use of the information provided in this guide. Users are advised to consult with qualified professionals and refer to official documentation for their specific Subspace Official Documentations and relevant systems when in doubt.
By proceeding with the use of this guide, you acknowledge and accept the terms of this disclaimer.
