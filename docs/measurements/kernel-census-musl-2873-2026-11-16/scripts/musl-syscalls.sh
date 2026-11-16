#!/bin/bash
# musl-syscalls.sh: the system calls by name, with their failures, of the three ways (`units`, `true`, `command`; see
# musl-loop.sh), each under `strace -f -c` (counts only, no timings: strace slows every call). The units' calls less
# `true`'s are the compiles' own. Writes results/musl/syscalls-MODE.txt. In one hold of the lock.
set -u
cd "$(dirname "$0")"
for mode in units true command; do
    strace -f -c -S calls -o "results/musl/syscalls-$mode.txt" -- taskset -c 2 scripts/musl-loop.sh "$mode" "$PWD/src/build/compiler" > /dev/null 2>&1
done
