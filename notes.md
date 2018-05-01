# Setup notes

Info on more things to (re)configure on a new system.

## Chinese input with Fcitx (15.10)

install

```
fcitx fcitx-pinyin fcitx-sunpinyin fcitx-googlepinyin fcitx-anthy fcitx-mozc fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt4
```

run `im-config`, choose `fcitx`

log out, in (restart X), now you can configure your input methods

## Caps / Hyper / Compose

More info: https://wiki.archlinux.org/index.php/X_KeyBoard_extension

This used to be done with xmodmap, and the xmodmap dotfile is still there
because it doesn't hurt (might still help on old systems). However newer systems
have the problem that XKB will override the xmodmap settings.

The fix, in /usr/share/X11/xkb/symbols/us add this section (I've added below the "euro" section since it relies on that)

```
partial alphanumeric_keys modifier_keys
xkb_symbols "arne" {
    // US with Euro symbol on the 5
    include "us(euro)"
    name[Group1]= "English (US, for Arne)";

    // Capslock = Ctrl
    include "capslock(ctrl_modifier)"

    // Right alt = compose
    include "compose(ralt)"

    // The old control keys are now Hyper keys
    key <LCTL> { [ Hyper_L ] };
    key <RCTL> { [ Hyper_R ] };
    modifier_map Mod3 { <LCTL>, <RCTL> };
};
```

in /usr/share/X11/xkb/rules/evdev.xml add an extra "arne" variant under the us layout

```
    <layout>
      <configItem>
        <name>us</name>
        <!-- snip -->
      </configItem>
      <variantList>

        <!-- START NEW SECTION -->
        <variant>
          <configItem>
            <name>arne</name>
            <description>English (US, for Arne)</description>
          </configItem>
        </variant>
        <!-- END NEW SECTION -->
```

You'll have to `sudo dpkg-reconfigure xkb-data` and log in/out again, but now you can select this custom keyboard in the fcitx config.

## Compose key

To just get the compose key, you can do this, more info on the [ArchLinux wiki](https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg#Configuring_compose_key)

```
setxkbmap -option compose:ralt
```

Also interesting to have a look at the possible options

```
grep "compose:" /usr/share/X11/xkb/rules/base.lst
```

Some other interesting options

- eurosign:e
- terminate:ctrl_alt_bksp
- caps:ctrl_modifier /  ctrl:nocaps (same thing?)
- grp:* -> switch to alternative layout. How does this play with fcitx?

## Packages

```
build-essential inkscape openssl sox gimp mplayer2 ffmpeg gitg libxml2-dev libxml2 libxslt1-dev
maven2 agave pavucontrol apt-file scrot ant gparted p7zip
gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-fluendo-mp3
pdftk ssed colordiff openssh-server tofrodos cowsay bsdgames openjdk-8-jdk unrar pandoc gnutls-bin
lame chromium-browser tmux htop zsh silversearcher-ag vim
```

possibly

```
redis-server zsnes dzen
network-manager-vpnc
libmysqlclient-dev mysql-client
compizconfig-settings-manager
```

To compile emacs

```
autoconf automake texinfo libgtk2.0-dev libxpm-dev libjpeg-dev libtiff5-dev libgif-dev libtinfo-dev
```

fonts

```
fonts-arphic-bkai00mp
fonts-arphic-bsmi00lp
fonts-arphic-gbsn00lp
fonts-arphic-gkai00mp
fonts-arphic-ukai
fonts-arphic-uming
fonts-babelstone-han
ttf-mscorefonts-installer
fonts-opensymbol
fonts-wqy-zenhei
ttf-anonymous-pro
fonts-inconsolata


ttf-unifont
ttf-engadget
ttf-essays1743
ttf-femkeklaver
ttf-goudybookletter
ttf-staypuft
ttf-summersby
ttf-radisnoir
ttf-bitstream-vera
ttf-adf-accanthis
ttf-adf-baskervald
ttf-adf-berenis
ttf-adf-gillius
ttf-adf-ikarius
ttf-adf-irianis
ttf-adf-libris
ttf-adf-mekanus
ttf-adf-oldania
ttf-adf-romande
ttf-adf-switzera
ttf-adf-tribun
ttf-adf-universalis
ttf-adf-verana
```

## Manual installation

* ruby-build
* phantomjs (still needed from source)
* nvm / node
* hub
* leiningen
* ngrok
* emacs
* Cloudberry

## ShuttleXpress

`/etc/udev/rules.d/90-shuttlexpress.rules`

-rw-rw-r-- 1 root root 222 Oct 28 11:51 ./udev/rules.d/90-shuttlexpress.rules

```
SUBSYSTEM=="input", GROUP="input", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0b33", ATTRS{idProduct}=="0020", MODE:="666", GROUP="plugdev", RUN="/bin/sh -c 'echo -n $kernel:1.0 > /sys/bus/usb/drivers/usbhid/unbind'"
```

## DNS

https://www.ctrl.blog/entry/resolvconf-tutorial

```
sudo apt remove --purge resolvconf
sudo sed 's/^dns/# dns/' -i /etc/NetworkManager/NetworkManager.conf
```

To recompile network-manager so it ignores devices created by docker:

```
sudo apt-get build-dep network-manager
cd /tmp
apt-get source network-manager
cd network-manager-1.2.6
cd debian/patches
wget https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/1458322/+attachment/4914082/+files/hide_unmanaged_interfaces.patch
cd -
dpkg-buildpackage -b -uc -us
cd /tmp
sudo dpkg -i *.deb
```

## WWW browser

```
sudo update-alternatives --config x-www-browser
```

### Cloudberry

Download: https://www.cloudberrylab.com/download-thanks.aspx?prod=cbbub1214

Troubleshoot

"/opt/local/CloudBerry Backup/bin/cbb" saveLog -p /tmp/cloudberry
