# Sway setup

See `.config/sway`

- nwg-panel (installed from repo)
  - requires: libgtk-layer-shell-dev libplayerctl-dev python3-i3ipc brightnessctl python3-dasbus
- bemenu

Brightness: add to video/input groups for brightness-udev to work.

```
sudo usermod -aG video $USER
sudo usermod -aG input $USER
newgrp video
newgrp input
```

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
pulseaudio-utils (pactl -> control sound volume)
wdisplays
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
rclone
```

Desktop Applications:

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
libreoffice
eog
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

Manual - see install scripts

```
sdkman
frp
pnpm
fnm
gcloud
jet
```

JVM tools (via sdkman):

```
java
maven
```

Docker:

```
docker.io
docker-compose-v2
```

Docker additional setup:

```
sudo usermod -aG docker $USER
newgrp docker
```

Ruby:

- https://github.com/postmodern/chruby
- https://github.com/postmodern/ruby-install


additionally need for kde connect:

```
qml6-module-qtcore
```

Bun:

```
curl -fsSL https://bun.sh/install | bash
```
