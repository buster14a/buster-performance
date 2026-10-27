#!/bin/bash
# The same executable without and with BUSTER_PROBE_TOUCH_VALUES, interleaved, the order rotating by round.
S=/home/david/buster-lab/inputs/sqlite-amalgamation-3530400
run() { env -u CPATH -u C_INCLUDE_PATH "$@" ./compiler-probe-touch --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o /dev/null 2>&1; }
for round in $(seq 1 20); do
  if [ $((round % 2)) -eq 0 ]; then
    run | awk '$1=="time-stage" {print "plain", $2, $3}'
    run BUSTER_PROBE_TOUCH_VALUES=1 | awk '$1=="time-stage" {print "touch", $2, $3}'
  else
    run BUSTER_PROBE_TOUCH_VALUES=1 | awk '$1=="time-stage" {print "touch", $2, $3}'
    run | awk '$1=="time-stage" {print "plain", $2, $3}'
  fi
done
