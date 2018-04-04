#!/bin/bash

# NOTE: This script is mainly invoked by udev rules for auto mounting.

# Usage:
# tri_mount [dev_file] [label]

[ "$#" != "2" ] && exit 1

declare -A mnt_dict=(
    ['movies']="/media/movies"
    ['videos']="/media/videos"
    ['games']="/media/games"
    ['backup_all']="/media/backup_all"
)

dev=$1
label=$(echo $2 | tr '[:upper:]' '[:lower:]')

function xfs_mount() {
    /bin/mount -o rw,noauto,dirsync,noexec,nodev $dev ${mnt_dict[$1]}
    exit 0
}

case $label in
    "movies" ) xfs_mount "movies" ;;
    "videos" ) xfs_mount "videos" ;;
    "games"  ) xfs_mount "games" ;;
    "backup_all"  ) xfs_mount "backup_all" ;;
esac
