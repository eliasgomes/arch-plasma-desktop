# Arch Plasma Desktop

## Pre-Installation

Download the ISO from https://www.archlinux.org/download/

Find out the name of your USB drive:

    lsblk

Copy the image to your USB drive:

    sudo dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync

### BIOS Configuration

System Configuration > SATA Operation > AHCI

**Note:** This will allow Linux to detect the NVME SSD.

## Installation

### Wi-Fi & Internet

    iwctl

    [iwd]# device list
    [iwd]# station wlan0 scan
    [iwd]# station wlan0 get-networks
    [iwd]# station wlan0 connect SSID
    [iwd]# station wlan0 show

### Time and Date

    timedatectl set-ntp true
    timedatectl status

### Partitions

    fdisk -l
    fdisk /dev/nvme0n1

    # /boot - /dev/nvme0n1p1 - EFI System       - 550 MiB
    # /     - /dev/nvme0n1p2 - Linux Filesystem - 200 GiB
    # /home - /dev/nvme0n1p3 - Linux Filesystem - 800 GiB
    # (no swap), 32 GiB of RAM :)

    mkfs.fat -F32 /dev/nvme0n1p1
    mkfs.ext4 /dev/nvme0n1p2
    mkfs.ext4 /dev/nvme0n1p3

    mount /dev/nvme0n1p2 /mnt
    mkdir /mnt/boot
    mount /dev/nvme0n1p1 /mnt/boot
    mkdir /mnt/home
    mount /dev/nvme0n1p3 /mnt/home

### Base System

    pacstrap /mnt base linux linux-firmware

    genfstab -U /mnt >> /mnt/etc/fstab

    arch-chroot /mnt

### Timezone and Clock

    ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
    hwclock --systohc

### Locale

    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    locale-gen

    echo "LANG=en_US.UTF-8" > /etc/locale.conf

### Hostname and Hosts

    echo "morrigan" > /etc/hostname

    echo "127.0.0.1 localhost morrigan" > /etc/hosts
    echo "::1 localhost morrigan" >> /etc/hosts

### Password

    passwd

### Boot Manager

    pacman -S grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="Arch Linux"
    grub-mkconfig -o /boot/grub/grub.cfg

### Basic Packages

    pacman -S base-devel sudo less zsh vim git github-cli openssh net-tools iwd networkmanager plasma konsole ark dolphin gwenview spectacle firefox vlc

### User

    useradd -m -s /usr/bin/zsh eliasgomes
    passwd eliasgomes

### DHCP

    /etc/iwd/main.conf

    [General]
    EnableNetworkConfiguration=true

### Enabling Network Services

    systemctl enable iwd
    systemctl enable NetworkManager

### Desktop Manager

    systemctl enable sddm

### Finish Installation

    exit
    umount -R /mnt
    reboot

## Post-Installation

### GitHub Authentication

    gh auth login
