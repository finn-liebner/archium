#!/bin/bash

# archium (v0.2) - a script to install Arch Linux
# Copyright (C) 2021 Finn Liebner
# https://github.com/finn-liebner/archium

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/.

loadkeys de-latin1
timedatectl set-ntp true
sleep 1
clear

echo -e "\e[1;34m"
echo "                  /#\                  "
echo "                 /###\                 "
echo "                /#####\                "
echo "               /#######\               "
echo "              /#########\              "
echo "             /###########\             "
echo "                  ########\            "
echo "           /###############\           "
echo "          /#################\          "
echo "         /###################\         "
echo "        /########-''''-#######\        "
echo "       /#######/        \######\       "
echo "      /########|        |#######\      "
echo "     /#########\        /###           "
echo "    /###########\      /##########\    "
echo "   /#####/                   \#####\   "
echo "  /##/                           \##\  "
echo " /#                                 #\ "
echo -e "\e[0;1m"
echo " <<<   Arch Linux Install Script   >>> "
echo " <<<    Finn Liebner 30/03/2021    >>> "
echo -e "\e[0m"

start=$(date +%s)

blk=$(lsblk -l -i -o NAME -d | sed '1d')
num=$(echo "$blk" | grep -c '')

if [ $num -eq 0 ]; then
  echo -e "\e[1;31mError - no storage devices\e[0m"
elif [ $num -eq 1 ]; then
  dev=$blk
else
  echo -e "\e[1;32mSelect:\e[0m"
  echo "$(lsblk -o NAME,TYPE,SIZE,MOUNTPOINT,MODEL)"
  echo -e "\e[1;32m"
  read input
  echo -e "\e[0m"
  dev=$input
fi

echo "Device = $dev"

(echo o; echo Y; echo w; echo Y) | gdisk /dev/$dev > /dev/null

# bios (EF02: BIOS-Boot / 8300: Linux filesystem)
(echo n; echo 1; echo 2048; echo +1M; echo EF02; echo n; echo 2; echo ; echo ; echo 8300; echo w; echo Y) | gdisk /dev/$dev > /dev/null

ptl=$(lsblk -l -i -o NAME -f /dev/$dev)
pt1=$(echo "$ptl" | sed '3!d')
pt2=$(echo "$ptl" | sed '4!d')

mkfs.ext4 -L arch /dev/$pt2

mount -L arch /mnt
mkdir -p /mnt/boot

################################################################################

function pkglist()
{
  case "$1" in
    AOR) local return='sudo networkmanager network-manager-applet pulseaudio mesa wayland gdm mutter gnome-control-center gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-terminal gnome-screenshot gnome-tweaks gnome-tweak-tool nautilus papirus-icon-theme arc-solid-gtk-theme gvfs-mtp gvfs-nfs atom firefox firefox-i18n-de firefox-ublock-origin';;

    AUR) local return='gnome-shell-extension-dash-to-panel-40-1-any gnome-shell-extension-arc-menu-48.2-1-any gnome-shell-extension-appindicator-34-1-any';;
  esac

  echo "$return"
}

################################################################################

(
  echo "##"
  echo "## Arch Linux repository mirrorlist"
  echo "## Generated on 2020-09-02"
  echo "##"
  echo ""
  echo "## Germany"
  echo "Server = https://ftp.halifax.rwth-aachen.de/archlinux/\$repo/os/\$arch"
  echo "Server = https://packages.oth-regensburg.de/archlinux/\$repo/os/\$arch"
  echo "Server = https://ftp.fau.de/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.f4st.host/archlinux/\$repo/os/\$arch"
  echo "Server = https://dist-mirror.fem.tu-ilmenau.de/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.fsrv.services/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.mikrogravitation.org/archlinux/\$repo/os/\$arch"
  echo "Server = https://ger.mirror.pkgbuild.com/\$repo/os/\$arch"
  echo "Server = https://mirror.pkgbuild.com/\$repo/os/\$arch"
  echo "Server = https://mirrors.n-ix.net/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.orbit-os.com/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.chaoticum.net/arch/\$repo/os/\$arch"
  echo "Server = https://phinau.de/arch/\$repo/os/\$arch"
  echo "Server = https://mirror.selfnet.de/archlinux/\$repo/os/\$arch"
  echo "Server = https://ftp.spline.inf.fu-berlin.de/mirrors/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.undisclose.de/archlinux/\$repo/os/\$arch"
  echo "Server = https://arch.unixpeople.org/\$repo/os/\$arch"
  echo ""
  echo "## Switzerland"
  echo "Server = https://mirror.init7.net/archlinux/\$repo/os/\$arch"
  echo "Server = https://pkg.adfinis-sygroup.ch/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.puzzle.ch/archlinux/\$repo/os/\$arch"
  echo ""
  echo "## Netherlands"
  echo "Server = https://mirror.i3d.net/pub/archlinux/\$repo/os/\$arch"
  echo "Server = https://archlinux.mirror.liteserver.nl/\$repo/os/\$arch"
  echo "Server = https://mirror.lyrahosting.com/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.neostrada.nl/archlinux/\$repo/os/\$arch"
  echo "Server = https://archlinux.mirror.pcextreme.nl/\$repo/os/\$arch"
  echo "Server = https://mirror.serverion.com/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror.tarellia.net/distr/archlinux/\$repo/os/\$arch"
  echo "Server = https://mirror-archlinux.webruimtehosting.nl/\$repo/os/\$arch"
  echo "Server = https://mirrors.xtom.nl/archlinux/\$repo/os/\$arch"
) > /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel linux-lts linux-firmware nano
pacman --noconfirm --needed --root /mnt -S netctl dhcpcd

genfstab -Up /mnt > /mnt/etc/fstab

echo "> install grub"

cat << EOF | arch-chroot /mnt/
  pacman --noconfirm -Syy
  pacman --noconfirm -S grub
  grub-install /dev/vda
  sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/gi' /etc/default/grub
  grub-mkconfig -o /boot/grub/grub.cfg
EOF

echo "> doing some basic stuff..."

cat << EOF | arch-chroot /mnt/
  echo "VM" > /etc/hostname
  echo "LANG=de_DE.UTF-8" > /etc/locale.conf
  echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
  echo "de_DE ISO-8859-1" >> /etc/locale.gen
  echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
  locale-gen
  localectl --no-convert set-keymap de-latin1-nodeadkeys
  echo "KEYMAP=de-latin1" > /etc/vconsole.conf
  echo "FONT=lat9w-16" >> /etc/vconsole.conf
  ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
  timedatectl set-local-rtc 0
  mkinitcpio -p linux-lts
EOF

echo "> add user"

cat << EOF | arch-chroot /mnt/
  useradd -u 1001 -m xenox
  echo "xenox ALL=(ALL) ALL" >> /etc/sudoers
  echo "root:root" | chpasswd
  echo "xenox:root" | chpasswd
EOF

echo "> install packages"

cat << EOF | arch-chroot /mnt/
  pacman --noconfirm --needed -S $(pkglist 'AOR')
EOF

echo "> enable services"

cat << EOF | arch-chroot /mnt/
  systemctl enable gdm
  systemctl enable NetworkManager.service
  systemctl enable --now systemd-timesyncd.service
  hwclock -w
EOF

echo "> install AUR packages"

cat << EOF | arch-chroot /mnt/
  curl https://raw.githubusercontent.com/finn-liebner/archium/master/pkg/gnome-shell-extension-dash-to-panel-40-1-any.pkg.tar.zst -o /home/xenox/dash.pkg.tar.zst
  curl https://raw.githubusercontent.com/finn-liebner/archium/master/pkg/gnome-shell-extension-arc-menu-48.2-1-any.pkg.tar.zst -o /home/xenox/menu.pkg.tar.zst
  curl https://raw.githubusercontent.com/finn-liebner/archium/master/pkg/gnome-shell-extension-appindicator-34-1-any.pkg.tar.zst -o /home/xenox/tray.pkg.tar.zst
  gnome-extensions list
  pacman --noconfirm -U /home/xenox/dash.pkg.tar.zst
  pacman --noconfirm -U /home/xenox/menu.pkg.tar.zst
  pacman --noconfirm -U /home/xenox/tray.pkg.tar.zst
  pacman --noconfirm --needed -S xdg-utils xdg-user-dirs libappindicator-{gtk2,gtk3}
  xdg-user-dirs-update
  rm /home/xenox/dash.pkg.tar.zst
  rm /home/xenox/menu.pkg.tar.zst
  rm /home/xenox/tray.pkg.tar.zst
EOF

echo "> set wallpaper"

cat << EOF | arch-chroot /mnt/ > /dev/null 2>&1
  curl -o /home/xenox/01.jpg https://wallpaperplay.com/walls/full/0/2/7/349867.jpg
  curl -o /home/xenox/02.jpg https://www.wallpaperflare.com/static/664/45/83/white-orange-spaceship-wallpaper.jpg
  chown xenox /home/xenox/{01.jpg,02.jpg}
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/xenox/01.jpg'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.background picture-uri 'file:///home/xenox/01.jpg'
EOF

echo "> gnome settings"

cat << EOF | arch-chroot /mnt/ > /dev/null 2>&1
  sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
  sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface toolkit-accessibility false
  sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface enable-animations false
  sudo -u gdm dbus-launch gsettings set org.gnome.desktop.lockdown disable-lock-screen false
  sudo -u xenox dbus-launch gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
  sudo -u xenox dbus-launch gnome-extensions enable dash-to-panel@jderose9.github.com
  sudo -u xenox dbus-launch gnome-extensions enable arc-menu@linxgem33.com
  sudo -u xenox dbus-launch gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
  sudo -u xenox dbus-launch gnome-extensions enable native-window-placement@gnome-shell-extensions.gcampax.github.com
  echo "Hidden=true" >> /usr/share/applications/gnome-online-accounts-panel.desktop
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'de')]"
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.privacy remember-recent-files false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
  sudo -u xenox dbus-launch gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Dark-solid'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark-solid'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface gtk-key-theme 'Default'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro Semi-Bold 10'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface enable-animations true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface show-battery-percentage true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface enable-hot-corners false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.interface clock-show-date true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.calendar show-weekdate true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.app-folders folder-children '[]'
  sudo -u xenox dbus-launch gsettings set org.gnome.online-accounts whitelisted-providers '[]'
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 3600
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'hibernate'
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'hibernate'
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'
  sudo -u xenox dbus-launch gsettings set org.gnome.shell.app-switcher current-workspace-only true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.wm.preferences num-workspaces 1
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature uint32 2700
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 21.0
  sudo -u xenox dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 8.0
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard delay uint32 500
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard numlock-state false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard repeat true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval uint32 30
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.mouse middle-click-emulation false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.mouse speed 0.0
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'default'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.mouse left-handed false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchscreen output ['', '', '']
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-button-map 'default'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad send-events 'enabled'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad speed 0.0
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad middle-click-emulation false
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad left-handed 'mouse'
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
  sudo -u xenox dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag-lock false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel panel-element-positions-monitors-sync true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel click-action 'CYCLE-MIN'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel intellihide false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel primary-monitor 0
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel multi-monitors true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel animate-show-apps true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel animate-app-switch false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel animate-window-launch false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel dot-position 'BOTTOM'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel dot-style-focused 'METRO'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel isolate-workspaces false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel scroll-icon-action 'NOTHING'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel scroll-panel-action 'NOTHING'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel show-appmenu false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel show-favorites true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel show-favorites-all-monitors true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel show-tooltip false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel show-window-previews false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel stockgs-force-hotcorner false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel stockgs-keep-dash false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel stockgs-keep-top-panel false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel stockgs-panelbtn-click-only false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel panel-size 50
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel tray-size 12
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel panel-element-positions '{"0":[{"element":"leftBox","visible":true,"position":"centerMonitor"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu menu-button-appearance 'Icon'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu menu-button-icon 'Arc_Menu_Icon'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu arc-menu-icon 5
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu custom-menu-button-icon-size 40.0
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu menu-hotkey 'Super_L'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu menu-layout 'Elementary'
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu menu-height 550
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu menu-width 300
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu right-panel-width 205
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu multi-lined-labels false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu multi-monitor true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu alphabetize-all-programs true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu button-icon-padding 0
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu disable-tooltips true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu enable-large-icons true
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu enable-menu-button-arrow false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu disable-searchbox-border false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu disable-recently-installed-apps false
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu gap-adjustment 0
  sudo -u xenox dbus-launch gsettings --schemadir /usr/share/gnome-shell/extensions/arc-menu@linxgem33.com/schemas/ set org.gnome.shell.extensions.arc-menu override-hot-corners false
EOF

echo "> configure automatic login"

cat << EOF | arch-chroot /mnt/ > /dev/null 2>&1
  echo "[daemon]" >> /etc/gdm/custom.conf
  echo "AutomaticLoginEnable=True" >> /etc/gdm/custom.conf
  echo "AutomaticLogin=xenox" >> /etc/gdm/custom.conf
EOF

echo "> hide some .desktop entries"

FILES="avahi-discover.desktop bssh.desktop bvnc.desktop electron10.desktop electron6.desktop lstopo.desktop org.gnome.Extensions.desktop org.gnome.Shell.Extensions.desktop qv4l2.desktop qvidcap.desktop"

for NAME in $FILES; do
  FILE="/mnt/usr/share/applications/$NAME"
  if test -f "$FILE"; then
    echo "$NAME"
    if ! grep -q "NoDisplay=true" "$FILE"; then
      echo "NoDisplay=true" >> "$FILE" | arch-chroot /mnt/ > /dev/null 2>&1
    fi
  fi
done

end=$(date +%s)
time=$(date -ud "@$((end-start))" +"%Mmin %Ssec")
echo -e "Installation completed. Lasted ${time}\n"
echo -e " \"umount -R /mnt && reboot\" to restart.\n"
