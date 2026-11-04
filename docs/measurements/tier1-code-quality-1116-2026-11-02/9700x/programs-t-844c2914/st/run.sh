#!/usr/bin/env bash
# run.sh BUILD OUTPUT [speedtest1 options...]: one run of st-BUILD from a fresh database on tmpfs; prints the
# microseconds from before its fork to after its wait, and its exit status.
rm -rf /tmp/1116-claude/run
mkdir -p /tmp/1116-claude/run/db /tmp/1116-claude/run/tmp
s=$EPOCHREALTIME
(cd /tmp/1116-claude/run/db && SQLITE_TMPDIR=/tmp/1116-claude/run/tmp taskset -c 2 /home/david/buster-fast-bench/1116-claude/programs-t-844c2914/st/st-$1 --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 "${@:3}" speedtest1.db > $2 2>&1)
status=$?
e=$EPOCHREALTIME
echo "$(( ${e/./} - ${s/./} )) $status"
