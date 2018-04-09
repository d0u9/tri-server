#!/bin/bash

# Usage:
# tri_umount [disk_label]

if [ "$#" != "1" ]; then
    echo "usage: $0 [disk_label]"
    exit 1
fi

# each val is the smb share name
declare -A mnt_dict=(
    ['/media/movies']="Movies"
    ['/media/videos']="Videos"
    ['/media/games']="Games"
    ['/media/backup_all']="Backup_all"
)

mnt_point=$1
mnt_path=$(mount -l | grep -i "/dev/sd[b-z]1.*$mnt_point" | awk '{print $3}')

if [ -z "$mnt_path" ]; then
    echo "Can't find the device"
    exit 1
fi

docker ps | grep samba > /dev/null 2>&1
if [ "$?" == "0" ]; then
    docker exec samba close ${mnt_dict[$mnt_path]}
fi

/bin/umount $mnt_path
