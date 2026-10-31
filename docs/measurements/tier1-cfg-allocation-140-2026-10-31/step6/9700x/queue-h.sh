#!/usr/bin/env bash
# queue-h.sh BASE HEAD REVISION: the selection walks' measurements: queue-g.sh (builds, compile times, speedtest1), then
# perf stat of speedtest1's Tier 0, --tier1 (head's, both paths, and base's) and clang -O2 builds, then queue-d.sh's
# campaign at the head.
set -u
cd ~/buster-fast-bench/claude-140-cfg || exit 1
./queue-g.sh "$1" "$2"
st=$PWD/st-g-$2
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 selection walks #140: perf stat"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
for c in t0 t1 t1s t1base clang2; do
    ~/buster-fast-bench/exclusive.sh bash -c "rm -rf /tmp/claude-140-st/run && mkdir -p /tmp/claude-140-st/run/db /tmp/claude-140-st/run/tmp && cd /tmp/claude-140-st/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u,branches:u,branch-misses:u -o $st/stat-$c.txt -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
done
./queue-d.sh "$2" "$3"
