#!/bin/bash
# pagecost.sh: tools/pagecost on CPU 2 (item 3), its file a copy of the frozen sqlite3.c on tmpfs and in this directory
# (btrfs), and its write cases on each; in one hold of the lock (lock.sh ./pagecost.sh).
set -u
cd "$(dirname "$0")"
out=results/pagecost
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
status=0
{ echo "== $(date -u +%FT%TZ)"; uname -a; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6;
  cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag; grep -E "MemFree|MemAvailable|AnonHugePages" /proc/meminfo; } >> "$out/host.txt"
cp "$sqlite" /dev/shm/2873-pagecost.c
cp "$sqlite" scratch/2873-pagecost.c
cat /dev/shm/2873-pagecost.c scratch/2873-pagecost.c > /dev/null
taskset -c 2 tools/pagecost --reps 9 --megabytes 256 /dev/shm/2873-pagecost.c /dev/shm > "$out/tmpfs.tsv" 2>> "$out/host.txt" || status=1
taskset -c 2 tools/pagecost --reps 9 --megabytes 256 --case file-map --case file-map-single --case file-map-single-empty --case file-populate \
    --case file-read-fresh --case file-read-reused --case file-write-new --case file-write-over scratch/2873-pagecost.c scratch > "$out/btrfs.tsv" 2>> "$out/host.txt" || status=1
taskset -c 2 tools/pagecost --reps 9 --megabytes 16 --case anon-4k-write --case anon-2m-write --case anon-4k-teardown --case anon-2m-teardown /dev/shm/2873-pagecost.c /dev/shm > "$out/small.tsv" 2>> "$out/host.txt" || status=1
{ echo "status $status"; cat /proc/loadavg; } >> "$out/host.txt"
rm -f /dev/shm/2873-pagecost.c scratch/2873-pagecost.c
exit $status
