#!/bin/bash
# job19.sh LABEL SUFFIX: LABEL (main fdf0de745 with LABEL.patch) built; the flat front before the walk and after it on
# sqlite3.c and Lua seven times and musl three; and the flat front's cycles, instructions and mispredicted branches by
# symbol on sqlite3.c, before the walk.
set -u
cd "$(dirname "$0")"
label=$1; suffix=$2
log=results/job19-$label.log
./build-label.sh $label fdf0de745 $label.patch > results/$label-build.out 2>&1 || { echo "$label build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./front-o.sh -$suffix 7 "$label flat --front-flat" "$label flatfirst --front-flat-first" || { echo "front-o failed" >> $log; exit 1; }
./front-musl-o.sh -$suffix 3 "$label flatfirst --front-flat-first" || { echo "musl failed" >> $log; exit 1; }
for c in sqlite3 lua musl; do for t in flat flatfirst; do echo "== $c $t"; python3 flats.py results/$label/front-$t-$c-$suffix-*.txt 2>/dev/null; done; done > results/flats-$label.txt 2>&1
./perf-events5-all.sh $label flatfirst --front-flat-first
echo "job19 done $(date -u +%FT%TZ)" >> $log
