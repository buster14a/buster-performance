#!/bin/bash
# job8.sh: the record's last runs of g2 (the pull request's sources): the shadow's one reading of sqlite3.c and Lua seven
# times after the walk, whole and lean; its fronts' events by symbol over five processes an event; and -c sqlite3.c by
# m10 (main dc582070) and g2 as whole processes from fresh copies of each executable.
set -u
cd "$(dirname "$0")"
./front-o.sh -i 7 "g2 after --front" "g2 leanafter --front-lean" "m10 after --front" || { echo "front-o failed" >> results/job8.log; exit 1; }
echo "front-o done $(date -u +%T)" >> results/job8.log
./perf-events5.sh g2 first --front-first
./perf-events5.sh g2 leanfirst --front-lean --front-first
./perf-events5.sh m10 first --front-first
echo "events done $(date -u +%T)" >> results/job8.log
./ab-copies.sh m10 g2
echo "job8 done $(date -u +%FT%TZ)" >> results/job8.log
