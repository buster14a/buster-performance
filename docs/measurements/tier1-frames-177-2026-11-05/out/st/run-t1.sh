#!/bin/bash
rm -rf "$1" "$1"-wal "$1"-shm "$1"-journal /tmp/177-claude-tmp; mkdir -p /tmp/177-claude-tmp
SQLITE_TMPDIR=/tmp/177-claude-tmp exec /home/david/buster-fast-bench/177-claude/out/st/speedtest1-t1 --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 "$1"
