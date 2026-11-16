#!/bin/bash
# musl-trace3.sh: the file system calls of musl's first three units as one command on one lane, by name and path
# (strace -f, no timings): what a unit of the command stats and opens. Writes results/musl/trace3.txt. In one hold of
# the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source scripts/musl-common.sh
mkdir -p /dev/shm/2873-musl-trace && cd /dev/shm/2873-musl-trace || exit 1
strace -f -e trace=openat,newfstatat,stat,lstat,access,getdents64 -o "$here/results/musl/trace3.txt" -- taskset -c 2 \
    "$here/src/build/compiler" "${options[@]}" --lanes 1 -c "${files[0]}" "${files[1]}" "${files[2]}" > /dev/null 2>&1
cd / && rm -rf /dev/shm/2873-musl-trace
