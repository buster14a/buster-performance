#!/bin/bash
# job3.sh LABEL PATCH: LABEL (main 6c59018e with PATCH) built; the shadow's one reading of sqlite3.c and Lua five times by
# f1 and LABEL in turn with --front-first and with --front; and LABEL's --front-first reading's events by symbol.
set -u
cd "$(dirname "$0")"
label=$1; patch=$2
./build-label.sh $label 6c59018e4 $patch > results/$label-build.out 2>&1 || { echo "$label build failed" >> results/job3.log; exit 1; }
echo "$label built $(date -u +%T)" >> results/job3.log
./front-o.sh -$label 5 "f1 first --front-first" "$label first --front-first" "f1 after --front" "$label after --front"
./perf-events.sh $label first --front-first
echo "$label done $(date -u +%FT%TZ)" >> results/job3.log
