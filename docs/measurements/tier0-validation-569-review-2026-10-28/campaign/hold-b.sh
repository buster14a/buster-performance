#!/usr/bin/env bash
# #569's second hold of the host's lock (queue3.sh): the switch's stages in each mode (measure-compile --runs 11), perf
# stat of main's and head's compiles (main, head, head, main, 11 runs each), then the switch's rounds (rounds.sh).
set -u
source "$(dirname "$0")/common.sh"
echo "== switch stages $(date +%T)"
for m in "${modes[@]}"; do
    BUSTER_569_VALIDATE=$m taskset -c 2 "$D/switch/build/compiler" measure-compile --runs 11 -- "${options[@]}" > "$D/stages-$m.txt" 2>&1
    echo "stages $m status $?"
done
echo "== perf main and head $(date +%T)"
rm -f "$D"/stat-main.txt "$D"/stat-head.txt
for t in main head head main; do
    (cd "$D/$t" && taskset -c 2 perf stat -r 11 -e task-clock,cycles:u,instructions:u,branch-misses:u -o "$D/stat-$t.txt" --append -- ./build/compiler "${options[@]}" -o "$TMPDIR/perf-$t.o" > /dev/null 2>&1)
    echo "perf $t status $?"
done
echo "== switch rounds $(date +%T)"
"$(dirname "$0")/rounds.sh"
echo "rounds status $?"
echo "== test-tier0 times $(date +%T)"
for t in main head; do
    (cd "$D/$t" && /usr/bin/time -f "test-tier0 $t: %e s elapsed, %U s user" taskset -c 2 ./build/compiler test-tier0 2>&1 | grep -E "^validation|test-tier0:|elapsed")
done
