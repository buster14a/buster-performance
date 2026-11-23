#!/bin/bash
# shm-hold.sh OUT: shm-bench on the 9700X, 256 MB, each mode five times on CPU 2; shmem_enabled=advise for the hold, never put back.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1; mkdir -p "$out"
setting=/sys/kernel/mm/transparent_hugepage/shmem_enabled
f=/dev/shm/shm-bench-01egbx
rm -f $f
{
    echo "shmem_enabled as found: $(cat $setting)"
    for i in 1 2 3 4 5; do taskset -c 2 "$dir/shm-bench" anon $((256 << 20)); done
    echo "-- the file made and reused with shmem_enabled never (base pages)"
    taskset -c 2 "$dir/shm-bench" make $((256 << 20)) $f
    for i in 1 2 3 4 5; do taskset -c 2 "$dir/shm-bench" reuse $((256 << 20)) $f; done
    rm -f $f
    sudo -n sh -c "echo advise > $setting"; echo "-- shmem_enabled now: $(cat $setting)"
    taskset -c 2 "$dir/shm-bench" make $((256 << 20)) $f
    grep -E "ShmemHugePages|ShmemPmdMapped" /proc/meminfo
    for i in 1 2 3 4 5; do taskset -c 2 "$dir/shm-bench" reuse $((256 << 20)) $f; done
    rm -f $f
    sudo -n sh -c "echo never > $setting"; echo "-- shmem_enabled put back: $(cat $setting)"
} > "$out/shm-bench.txt" 2>&1
echo done > "$out/complete"
