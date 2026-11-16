#!/bin/bash
cd "$(dirname "$0")"
until grep -q finished rows.done 2> /dev/null; do sleep 10; done
./lock.sh timeout -k 10 600 ./events.sh results/events-sqlite 21 "head=$PWD/head/build/compiler" "p2=$PWD/full/build/compiler" > results/events-sqlite.log 2>&1
echo finished > events.done
