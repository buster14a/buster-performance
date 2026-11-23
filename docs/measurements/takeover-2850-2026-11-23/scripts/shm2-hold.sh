#!/bin/bash
# shm2-hold.sh OUT: shm-bench's reuse with the file on a tmpfs mounted huge=always for this hold alone (a tmpfs file's
# huge pages are its mount's option, not shmem_enabled's), then unmounted.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1; mkdir -p "$out"
mnt="$dir/hugetmp"
mkdir -p "$mnt"
{
    sudo -n mount -t tmpfs -o huge=always,size=1G,mode=0700,uid=$(id -u) tmpfs "$mnt" && echo "mounted: $(grep " $mnt " /proc/mounts)"
    for i in 1 2 3; do taskset -c 2 "$dir/shm-bench" anon $((256 << 20)); done
    taskset -c 2 "$dir/shm-bench" make $((256 << 20)) "$mnt/pool"
    grep -E "ShmemHugePages|ShmemPmdMapped" /proc/meminfo
    for i in 1 2 3 4 5; do taskset -c 2 "$dir/shm-bench" reuse $((256 << 20)) "$mnt/pool"; done
    rm -f "$mnt/pool"
    sudo -n umount "$mnt" && echo unmounted
    grep -c " $mnt " /proc/mounts
} > "$out/shm-bench-huge.txt" 2>&1
echo done > "$out/complete"
