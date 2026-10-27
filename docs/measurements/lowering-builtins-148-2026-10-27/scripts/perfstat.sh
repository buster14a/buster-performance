#!/usr/bin/env bash
# perfstat.sh PID: after process PID (rounds.sh) ends, one lock hold of perf stat -r 11 (user instructions and cycles)
# of -c sqlite3.c on each tree, pinned to CPU 2, the trees interleaved twice in rotated order.
set -u
cd "$(dirname "$0")"
while kill -0 "$1" 2>/dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=ld148-claude EXCLUSIVE_TITLE="#148 long double and __int128 builtins: perf stat" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
~/buster-fast-bench/exclusive.sh bash -c '
    for t in main head main2 head main main2; do
        echo "== $t"
        taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u $t/build/compiler -c -o '"$PWD"'/ab.o '"$SQLITE"' 2>&1 >/dev/null
    done' > perfstat.log 2>&1
echo done >> perfstat.log
