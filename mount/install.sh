#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Permission denied"
   exit 1
fi


user=app
group=app
target_dir=/usr/local/bin

rm -fr "$target_dir/tri-umount"
install -o $user -g $group  tri-umount.sh "$target_dir/tri-umount"

rm -fr "$target_dir/tri-mount"
install -o $user -g $group tri-mount.sh "$target_dir/tri-mount"

rm -fr /etc/udev/rules.d/90-trident.rules
install -o root -g root -m 644 udev/90-trident.rules /etc/udev/rules.d/
udevadm control --reload-rules
udevadm trigger
