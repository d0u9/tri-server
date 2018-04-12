#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Permission denied"
   exit 1
fi

user=app
group=app

local_bin_list="tri-smb-start
                tri-smb-stop"

target_dir=/usr/local/bin
for f in $local_bin_list; do
    rm -fr "$target_dir/$f"
    install -o $user -g $group  $f "$target_dir/$f"
done


