#!/bin/bash
# retime.sh: after run-front.sh, more rounds of time.sh by main (m3) and the change (pr) in turn, each its own hold: main
# lacked its first round (the hold timed out) and one of its runs on sqlite3.c ran slow throughout.
set -u
cd "$(dirname "$0")"
while pgrep -f run-front.sh > /dev/null; do sleep 20; done
for n in 1 4 5 6; do
    ./time.sh m3 -f$n > /dev/null 2>&1
    if [ $n != 1 ]; then ./time.sh pr -f$n > /dev/null 2>&1; fi
    echo "round $n $(date -u +%T)"
done
echo retimed
