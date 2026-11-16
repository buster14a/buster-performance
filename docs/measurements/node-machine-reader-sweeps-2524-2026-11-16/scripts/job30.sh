#!/bin/bash
# job30.sh: C and X where they sit, on the pull request's sources. w2 (main be6515fba with w2.patch: w1 with the tests'
# last fixture lines) built; the shadow on sqlite3.c and Lua seven times and on musl three times, the specs in turn: T
# alone at reader time by u3 (#2867's branch at that main) and by w2 and T, C and X there by w2, each with the whole
# front and with the lean one, and the shadow's own sweeps by both in seven passes (one on musl); -c sqlite3.c by u3 and
# w2 as whole processes from fresh copies, twice; the fact words' kernels by both, runs 13 to 18, as job21 ran them; and
# the executables' symbols compared.
set -u
cd "$(dirname "$0")"
log=results/job30.log
./build-label.sh w2 be6515fba w2.patch > results/w2-build.out 2>&1 || { echo "w2 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./types-o2.sh -t 1 7 "u3 types1 --front-types --passes 1" "w2 types1 --front-types --passes 1" "w2 sweeps1 --front-sweeps --passes 1" "u3 leantypes1 --front-lean --front-types --passes 1" "w2 leantypes1 --front-lean --front-types --passes 1" "w2 leansweeps1 --front-lean --front-sweeps --passes 1" "u3 plain7 --passes 7" "w2 plain7 --passes 7" || { echo "types-o2 failed" >> $log; exit 1; }
test -s results/w2/types-plain7-sqlite3-t-7.txt || { echo "types-o2 made no files" >> $log; exit 1; }
echo "types done $(date -u +%T)" >> $log
./types-musl-o.sh -t 3 "u3 types1 --front-types --passes 1" "w2 types1 --front-types --passes 1" "w2 sweeps1 --front-sweeps --passes 1" "u3 leantypes1 --front-lean --front-types --passes 1" "w2 leantypes1 --front-lean --front-types --passes 1" "w2 leansweeps1 --front-lean --front-sweeps --passes 1" "u3 plain1 --passes 1" "w2 plain1 --passes 1" || { echo "musl failed" >> $log; exit 1; }
echo "musl done $(date -u +%T)" >> $log
./ab-copies-n.sh u3 w2 2 > results/ab-u3-w2.out 2>&1
echo "ab done $(date -u +%T)" >> $log
python3 symdiff.py results/u3/compiler results/w2/compiler > results/symbols-u3-w2.txt 2>&1
for l in u3 w2; do echo "== $l"; nm -S results/$l/compiler | grep -i " node_facts_\| node_machine_\(type\|contexts\|expand\|classify\|own\|rule\|update_plan\|number_labels\)" | sort -k4; done > results/addresses-u3-w2.txt
for n in 13 14 15 16 17 18; do
    for label in u3 w2; do
        RUN=$n ./facts.sh $label "" 1 --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-lean" 1 --facts-lean --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loads" 1 --facts-loads --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed" 1 --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-leanpacked" 1 --facts-lean --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loadspacked" 1 --facts-loads --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed4096" 1 --facts-packed --facts-window 4096 --passes 5 --list 20 > /dev/null
    done
    echo "facts round $n done $(date -u +%T)" >> $log
done
echo "job30 done $(date -u +%FT%TZ)" >> $log
