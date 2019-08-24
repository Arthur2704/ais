#!bin/bash
disk=sda
boot=sda1
swap=sda2
root=sda3
password=

mkfs.ext4 "/dev/$boot"
mkswap "/dev/$swap"
swapon "/dev/$swap"
mkfs.ext4 "/dev/$root"

mount "/dev/$root" "/mnt"
mkdir /mnt/boot /mnt/home /mnt/var
mount "/dev/$boot" "/mnt/boot"

pacstrap /mnt base base-devel
pacstrap /mnt grub-bios

genfstab -p /mnt >> /mnt/etc/fstab

echo "hwclock --systohc --utc
mkinitcpio -p linux
echo "root:$password" | chpasswd
grub-install "/dev/$disk"
grub-mkconfig -o /boot/grub/grub.cfg
exit" >> /mnt/script.sh

arch-chroot /mnt sh script.sh

rm /mnt/script.sh

echo "Install done"
