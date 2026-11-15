#!/bin/bash
# job6.sh: m10 (main dc582070, #2857 merged) and g1 (it with g1.patch: the front's structural bytes and the lean front)
# built; the shadow's one reading of sqlite3.c and Lua seven times and of musl three times by g1 with no option (the
# walk as it is), --front-first, --front-lean --front-first, --front and --front-lean, and by m10 with --front-first
# (#2857's front as merged), in turn; the whole and the lean front's events by symbol; and -c sqlite3.c by m10 and g1
# as whole processes from fresh copies of each executable.
set -u
cd "$(dirname "$0")"
./build-label.sh m10 dc5820703 > results/m10-build.out 2>&1 || { echo "m10 build failed" >> results/job6.log; exit 1; }
./build-label.sh g1 dc5820703 g1.patch > results/g1-build.out 2>&1 || { echo "g1 build failed" >> results/job6.log; exit 1; }
echo "built $(date -u +%T)" >> results/job6.log
./front-o.sh -g 7 "g1 walk" "m10 first --front-first" "g1 first --front-first" "g1 leanfirst --front-lean --front-first" "g1 after --front" "g1 leanafter --front-lean" || { echo "front-o failed" >> results/job6.log; exit 1; }
test -s results/g1/front-leanfirst-sqlite3-g-7.txt || { echo "front-o made no files" >> results/job6.log; exit 1; }
echo "front-o done $(date -u +%T)" >> results/job6.log
./front-musl-o.sh -g 3 "g1 walk" "m10 first --front-first" "g1 first --front-first" "g1 leanfirst --front-lean --front-first" || { echo "musl failed" >> results/job6.log; exit 1; }
echo "musl done $(date -u +%T)" >> results/job6.log
./perf-events.sh g1 first --front-first
./perf-events.sh g1 leanfirst --front-lean --front-first
echo "events done $(date -u +%T)" >> results/job6.log
./ab-copies.sh m10 g1
echo "job6 done $(date -u +%FT%TZ)" >> results/job6.log
