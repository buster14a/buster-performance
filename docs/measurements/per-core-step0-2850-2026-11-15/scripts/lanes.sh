#!/bin/bash
# usage: ./lanes.sh [DUMPS] ; builds tools/lanes.c (step 0's second path; it includes tools/census.c and, through it,
# tools/sweeps.c, the one-core record's prototype, unchanged) and times it over that record's two dumps in DUMPS
# (default scratch/: sqlite3.dump and musl.dump). Two builds a dump: the rules read at run time, and the same rules
# baked as straight-line code (lanes --bake). Every run checks the second path against the first, entry for entry.
#
# These are timings: on the 9700X, with LOCK the host's lock's command, which each build and each run takes by itself
# (LOCK=~/buster-fast-bench/exclusive.sh, with EXCLUSIVE_OWNER, EXCLUSIVE_TITLE and EXCLUSIVE_LINK set), pinned to
# CPU (default 2). Results in ../results/lanes.
set -euo pipefail
cd "$(dirname "$0")"
dumps=${1:-scratch}
out=../results/lanes
mkdir -p "$out" build
lock=${LOCK:-}
cpu=${CPU:-2}
flags="-O3 -g -march=native -Wall -Wextra"
locked() { if [ -n "$lock" ]; then "$lock" "$@"; else "$@"; fi; }
run() { local name=$1; shift; locked taskset -c "$cpu" "$@" > "$out/$name.txt"; }
{
    sha256sum tools/sweeps.c tools/census.c tools/lanes.c
    (cd "$dumps" && sha256sum sqlite3.dump musl.dump)
    clang --version | head -1
    echo "host: $(uname -srm); $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')"
} > "$out/lanes-hashes.txt"
locked clang $flags -o build/lanes tools/lanes.c 2> "$out/lanes-build.log"
for unit in sqlite3 musl; do
    locked build/lanes "$dumps/$unit.dump" --bake "build/baked-$unit.h"
    cp "build/baked-$unit.h" "$out/baked-$unit.h"
    locked clang $flags -DLANES_BAKED="\"$PWD/build/baked-$unit.h\"" -o "build/lanes-$unit" tools/lanes.c 2>> "$out/lanes-build.log"
done
# The whole's time, three processes each; the parts' (--split reads the counters at each part, so its whole is not the
# time); and each pass after 200 ms of the first path's scalar work.
for unit in sqlite3 musl; do
    for i in 1 2 3; do
        run "baked-$unit-$i" "build/lanes-$unit" "$dumps/$unit.dump" --passes 21 --first-passes 5
        run "read-$unit-$i" build/lanes "$dumps/$unit.dump" --passes 21 --first-passes 5
    done
    run "baked-$unit-split" "build/lanes-$unit" "$dumps/$unit.dump" --passes 21 --first-passes 5 --split
    run "read-$unit-split" build/lanes "$dumps/$unit.dump" --passes 21 --first-passes 5 --split
    run "baked-$unit-after-scalar" "build/lanes-$unit" "$dumps/$unit.dump" --passes 21 --first-passes 5 --after-scalar 200
done
# Where the first-level cache's fills come from, back to back and after the first path's 200 ms: a raw event of the
# processor's in the mispredicted branches' place (144: fills from the second-level cache; 244: from the third; 4844:
# from memory).
for event in 144 244 4844; do
    run "fills-$event-sqlite3" build/lanes-sqlite3 "$dumps/sqlite3.dump" --passes 21 --first-passes 2 --raw "$event"
    run "fills-$event-sqlite3-after-scalar" build/lanes-sqlite3 "$dumps/sqlite3.dump" --passes 21 --first-passes 2 --raw "$event" --after-scalar 200
done
# The window: records a window (0: the unit as one).
for window in 256 1024 16384 0; do
    run "baked-sqlite3-window-$window" build/lanes-sqlite3 "$dumps/sqlite3.dump" --passes 21 --first-passes 2 --window "$window"
done
# X's rows' loop as experiments (lanes.c's LANES_ROWS_VARIANT): 1, 7 and 8 write the same entries; 2 to 5 leave parts
# out for their time alone, so their entries are wrong and their runs fail the check.
for variant in 1 2 3 4 5 7 8; do
    locked clang $flags -DLANES_BAKED="\"$PWD/build/baked-sqlite3.h\"" -DLANES_ROWS_VARIANT=$variant -o build/lanes-variant tools/lanes.c 2>> "$out/lanes-build.log"
    run "rows-variant-$variant" build/lanes-variant "$dumps/sqlite3.dump" --passes 11 --first-passes 2 --split || true
done
echo done > "$out/lanes.done"
