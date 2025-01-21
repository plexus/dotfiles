# Sway setup

See `.config/sway`

- nwg-panel (installed from repo)
  - requires: libgtk-layer-shell-dev libplayerctl-dev python3-i3ipc brightnessctl python3-dasbus
- bemenu

# packages

Sway setup:

```
sddm
sway
swayidle
swaylock
bemenu
brightness-udev
brightnessctl
grim
slurp
nm-applet (nm-tray?)
xdg-desktop-portal-wlr
```

System tools:

```
apt-file
btop
git
htop
hub
libnotify-bin #notify-send
locate
tmux
xdg-utils
zip
zsh
rlwrap
netcat-openbsd
powertop
tree
```

Applications:

```
thunar
dolphin
pacmanfm-qt
nautilus
kitty
pavucontrol
inkscape
evince
kdeconnect
```

nwg-panel:

```
libayatana-appindicator3-dev
libdbusmenu-gtk3-dev
libgtk-layer-shell-dev
libplayerctl-dev
python3-dasbus
python3-gi-cairo
python3-i3ipc
python3-psutil
```

Manual

```
frp
pnpm
fnm
```

Extra dev tooling:

```
docker.io
docker-compose-v2
```

```
sudo usermod -aG docker $USER
newgrp docker
```

additionally need for kde connect:

```
qml6-module-qtcore
```
