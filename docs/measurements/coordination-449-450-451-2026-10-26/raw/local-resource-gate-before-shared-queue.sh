#!/bin/bash
set -eu
case "$1" in
    A) cpus=0,1; quota=200% ;;
    B) cpus=2,3; quota=200% ;;
    C) cpus=4,5; quota=200% ;;
    A-test|B-test|C-test) cpus=0-7; quota=800% ;;
    *) exit 2 ;;
esac
shift
directory=$(cd -- "$(dirname -- "$0")" && pwd)
exec flock "$directory/validation.lock" systemd-run --user --scope --quiet -p "AllowedCPUs=$cpus" -p "CPUQuota=$quota" -p MemoryMax=8G taskset -c "$cpus" env BUSTER_DEBUG_INFO=0 OMP_NUM_THREADS=1 MAKEFLAGS=-j2 "$@"
