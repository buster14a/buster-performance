#!/bin/bash
# final-p2.sh: piece 2 as it is: its build, the pull request's head against it (series-p2.sh, with the tests), and the
# peak resident set of sqlite3.c's -c and of an empty file's -c by the head and by it. A hold of the lock each.
cd "$(dirname "$0")"
: > final-p2.done
./series-p2.sh
./lock.sh timeout -k 10 900 ./peak.sh results/peak 11 "head=$PWD/head/build/compiler" "p2=$PWD/full/build/compiler" > results/peak.log 2>&1
./lock.sh timeout -k 10 900 ./peak-empty.sh results/peak-empty 11 "head=$PWD/head/build/compiler" "p2=$PWD/full/build/compiler" > results/peak-empty.log 2>&1
echo finished > final-p2.done
