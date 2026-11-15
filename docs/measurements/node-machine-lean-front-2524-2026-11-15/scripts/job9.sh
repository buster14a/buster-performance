#!/bin/bash
# job9.sh: g3 (main dc582070 with g3.patch: the pull request's sources, g2 with the front's hooks in the walk moved out of
# line) built; -c sqlite3.c by m10 (main dc582070) and g3 as whole processes from fresh copies of each executable; the
# shadow's one reading of sqlite3.c and Lua seven times and of musl three times by m10 (#2857's front) and by g3's whole
# and lean fronts, before and after the walk, cold and with their arrays touched beforehand, and g3's walk as it is, in
# turn; and g3's fronts' events by symbol over five processes an event.
set -u
cd "$(dirname "$0")"
./build-label.sh g3 dc5820703 g3.patch > results/g3-build.out 2>&1 || { echo "g3 build failed" >> results/job9.log; exit 1; }
echo "built $(date -u +%T)" >> results/job9.log
./ab-copies.sh m10 g3
echo "ab done $(date -u +%T)" >> results/job9.log
./front-o.sh -j 7 "m10 first --front-first" "g3 first --front-first" "g3 leanfirst --front-lean --front-first" "g3 warmfirst --front-first --front-warm" "g3 leanwarmfirst --front-lean --front-first --front-warm" "g3 walk" "m10 after --front" "g3 after --front" "g3 leanafter --front-lean" || { echo "front-o failed" >> results/job9.log; exit 1; }
test -s results/g3/front-leanafter-sqlite3-j-7.txt || { echo "front-o made no files" >> results/job9.log; exit 1; }
echo "front-o done $(date -u +%T)" >> results/job9.log
./front-musl-o.sh -j 3 "m10 first --front-first" "g3 first --front-first" "g3 leanfirst --front-lean --front-first" "g3 warmfirst --front-first --front-warm" "g3 leanwarmfirst --front-lean --front-first --front-warm" "g3 walk" || { echo "musl failed" >> results/job9.log; exit 1; }
echo "musl done $(date -u +%T)" >> results/job9.log
./perf-events5.sh g3 first --front-first
./perf-events5.sh g3 leanfirst --front-lean --front-first
echo "events done $(date -u +%T)" >> results/job9.log
./ab-copies.sh m10 g3
mv results/ab-copies-m10-g3 results/ab-copies-m10-g3-second 2>/dev/null
echo "job9 done $(date -u +%FT%TZ)" >> results/job9.log
