#!/usr/bin/env bash
# queue-k.sh BASE HEAD REVISION: #977 review follow-ups: queue-g-k.sh (builds, compile times, speedtest1), queue-i-k.sh
# (--tier1 -c), perf stat of the --tier1 builds, and a #142 campaign at the head, seeds 3400 to 3419.
set -u
cd ~/buster-fast-bench/claude-140-cfg || exit 1
./queue-g-k.sh "$1" "$2"
./queue-i-k.sh "$1" "$2"
st=$PWD/st-g-$2
export EXCLUSIVE_OWNER=claude-140-cfg EXCLUSIVE_TITLE="Tier 1 #141: #977 review follow-ups, perf stat" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/141
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
for c in t0 t1 t1s t1base; do
    ~/buster-fast-bench/exclusive.sh bash -c "rm -rf /tmp/claude-140-st/run && mkdir -p /tmp/claude-140-st/run/db /tmp/claude-140-st/run/tmp && cd /tmp/claude-140-st/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u -o $st/stat-$c.txt -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
done
./queue-d-k.sh "$2" "$3"
echo done > logs-g-$2/k-done
