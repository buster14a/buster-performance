#!/bin/bash
# job16.sh: the flat front, first reading. v1 (main fdf0de745 with v1.patch: #2867's branch merged and the flat front)
# built; on sqlite3.c and Lua seven times and musl three, the specs in turn: the flat front after the walk beside the
# lean one, the flat front before the walk (the lean one after), and the lean front before the walk; then the flat
# front's and the lean front's cycles, instructions and mispredicted branches by symbol on sqlite3.c, each before the walk.
set -u
cd "$(dirname "$0")"
log=results/job16.log
./build-label.sh v1 fdf0de745 v1.patch > results/v1-build.out 2>&1 || { echo "v1 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./front-o.sh -p 7 "v1 flat --front-flat" "v1 flatfirst --front-flat-first" "v1 leanfirst --front-first --front-lean" || { echo "front-o failed" >> $log; exit 1; }
echo "front-o done $(date -u +%T)" >> $log
./front-musl-o.sh -p 3 "v1 flat --front-flat" "v1 flatfirst --front-flat-first" "v1 leanfirst --front-first --front-lean" || { echo "musl failed" >> $log; exit 1; }
echo "musl done $(date -u +%T)" >> $log
for c in sqlite3 lua musl; do for t in flat flatfirst leanfirst; do echo "== $c $t"; python3 flats.py results/v1/front-$t-$c-p-*.txt; done; done > results/flats-v1.txt 2>&1
./perf-events5.sh v1 flatfirst --front-flat-first
./perf-events5.sh v1 leanfirst --front-first --front-lean
echo "job16 done $(date -u +%FT%TZ)" >> $log
