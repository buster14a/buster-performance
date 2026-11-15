#!/bin/bash
# job7.sh: g2 (main dc582070 with g2.patch: g1 with the passing tokens' fast path before the class dispatch, a valueless
# terminator's reads skipped, and --front-warm) built; the shadow's one reading of sqlite3.c and Lua seven times and of
# musl three times, before the walk, by m10 (#2857's front), g1's lean front and g2's whole and lean fronts, cold and with
# their arrays touched beforehand (--front-warm), in turn; and g2's fronts' events by symbol.
set -u
cd "$(dirname "$0")"
./build-label.sh g2 dc5820703 g2.patch > results/g2-build.out 2>&1 || { echo "g2 build failed" >> results/job7.log; exit 1; }
echo "built $(date -u +%T)" >> results/job7.log
./front-o.sh -h 7 "m10 first --front-first" "g1 leanfirst --front-lean --front-first" "g2 first --front-first" "g2 leanfirst --front-lean --front-first" "g2 warmfirst --front-first --front-warm" "g2 leanwarmfirst --front-lean --front-first --front-warm" "g2 walk" || { echo "front-o failed" >> results/job7.log; exit 1; }
test -s results/g2/front-leanwarmfirst-sqlite3-h-7.txt || { echo "front-o made no files" >> results/job7.log; exit 1; }
echo "front-o done $(date -u +%T)" >> results/job7.log
./front-musl-o.sh -h 3 "m10 first --front-first" "g1 leanfirst --front-lean --front-first" "g2 first --front-first" "g2 leanfirst --front-lean --front-first" "g2 warmfirst --front-first --front-warm" "g2 leanwarmfirst --front-lean --front-first --front-warm" "g2 walk" || { echo "musl failed" >> results/job7.log; exit 1; }
echo "musl done $(date -u +%T)" >> results/job7.log
./perf-events.sh g2 first --front-first
./perf-events.sh g2 leanfirst --front-lean --front-first
echo "job7 done $(date -u +%FT%TZ)" >> results/job7.log
