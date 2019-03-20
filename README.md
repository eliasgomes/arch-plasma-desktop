# arch-i3-desktop

## Pre-Installation

Download the ISO from https://www.archlinux.org/download/


Find out the name of your USB drive:

    lsblk

Copy the image to your USB drive:

    sudo dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync

BIOS:
    System Configuration > SATA Operation > AHCI
    Note: This will allow Linux to detect the NVME SSD.

## Installation

### Network/Internet

    ip link
    ip link set interface up
    wpa_passphrase MYSSID passphrase > /etc/wpa_supplicant/example.conf
    wpa_supplicant -B -i interface -c /etc/wpa_supplicant/example.conf
    dhcpcd interface

or

    wifi-menu # :)

### Undefined

    timedatectl set-ntp true
    timedatectl status

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

    pacstrap /mnt base base-devel dialog wpa_supplicant

    genfstab -U /mnt >> /mnt/etc/fstab

    arch-chroot /mnt

    ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
    hwclock --systohc

    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

    echo "morrigan" > /etc/hostname

    echo "127.0.0.1 localhost morrigan" > /etc/hosts
    echo "::1 localhost morrigan" >> /etc/hosts

    passwd

    pacman -S grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="Arch Linux"
    grub-mkconfig -o /boot/grub/grub.cfg

    exit

    umount -R /mnt
    reboot

## Post-Installation

    pacman -S sudo zsh vim git xorg-server xorg-xinit i3 termite firefox
    useradd -m -s /usr/bin/zsh eliasgomes

## Files

    /etc/sudoers
    .xinitrc
    .Xresources
