#!/bin/bash
# job20.sh: the flat front's final build. v4 (main fdf0de745 with v4.patch: #2867's branch merged and the pull request's
# sources) built; the flat front before the walk and after it on sqlite3.c and Lua seven times and musl three, with the
# lean front before the walk in the same runs' turn; its cycles, instructions and mispredicted branches by symbol on
# sqlite3.c, before the walk; and -c sqlite3.c by u1 (the base: main with #2867) and v4 as whole processes from fresh
# copies of each executable, twice.
set -u
cd "$(dirname "$0")"
log=results/job20.log
./build-label.sh v4 fdf0de745 v4.patch > results/v4-build.out 2>&1 || { echo "v4 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./front-o.sh -w 7 "v4 flat --front-flat" "v4 flatfirst --front-flat-first" "v4 leanfirst --front-first --front-lean" || { echo "front-o failed" >> $log; exit 1; }
./front-musl-o.sh -w 3 "v4 flat --front-flat" "v4 flatfirst --front-flat-first" "v4 leanfirst --front-first --front-lean" || { echo "musl failed" >> $log; exit 1; }
for c in sqlite3 lua musl; do for t in flat flatfirst leanfirst; do echo "== $c $t"; python3 flats.py results/v4/front-$t-$c-w-*.txt 2>/dev/null; done; done > results/flats-v4.txt 2>&1
echo "fronts done $(date -u +%T)" >> $log
./perf-events5-all.sh v4 flatfirst --front-flat-first
./ab-copies-n.sh u1 v4 2
python3 symdiff.py results/u1/compiler results/v4/compiler > results/symbols-u1-v4.txt
echo "job20 done $(date -u +%FT%TZ)" >> $log
