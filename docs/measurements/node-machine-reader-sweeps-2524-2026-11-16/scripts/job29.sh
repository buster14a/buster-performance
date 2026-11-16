#!/bin/bash
# job29.sh: C and X where they sit. w1 (main be6515fba with w1.patch: #2867's branch and C and X at reader time) built;
# the shadow on sqlite3.c and Lua seven times and on musl three times, the specs in turn: T alone at reader time by u3
# (#2867's branch at that main) and by w1, T, C and X there by w1 with the lean front and with the whole one, and the
# shadow's own sweeps by both in seven passes (one on musl); -c sqlite3.c by u3 and w1 as whole processes from fresh
# copies, twice; the fact words' kernels by both, runs 7 to 12, as job21 ran them; and the executables' symbols compared.
set -u
cd "$(dirname "$0")"
log=results/job29.log
./build-label.sh w1 be6515fba w1.patch > results/w1-build.out 2>&1 || { echo "w1 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./types-o2.sh -s 1 7 "u3 leantypes1 --front-lean --front-types --passes 1" "w1 leantypes1 --front-lean --front-types --passes 1" "w1 leansweeps1 --front-lean --front-sweeps --passes 1" "w1 sweeps1 --front-sweeps --passes 1" "u3 plain7 --passes 7" "w1 plain7 --passes 7" || { echo "types-o2 failed" >> $log; exit 1; }
test -s results/w1/types-plain7-sqlite3-s-7.txt || { echo "types-o2 made no files" >> $log; exit 1; }
echo "types done $(date -u +%T)" >> $log
./types-musl-o.sh -s 3 "u3 leantypes1 --front-lean --front-types --passes 1" "w1 leantypes1 --front-lean --front-types --passes 1" "w1 leansweeps1 --front-lean --front-sweeps --passes 1" "u3 plain1 --passes 1" "w1 plain1 --passes 1" || { echo "musl failed" >> $log; exit 1; }
echo "musl done $(date -u +%T)" >> $log
./ab-copies-n.sh u3 w1 2 > results/ab-u3-w1.out 2>&1
echo "ab done $(date -u +%T)" >> $log
for n in 7 8 9 10 11 12; do
    for label in u3 w1; do
        RUN=$n ./facts.sh $label "" 1 --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-lean" 1 --facts-lean --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loads" 1 --facts-loads --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed" 1 --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-leanpacked" 1 --facts-lean --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loadspacked" 1 --facts-loads --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed4096" 1 --facts-packed --facts-window 4096 --passes 5 --list 20 > /dev/null
    done
done
echo "facts done $(date -u +%T)" >> $log
python3 symdiff.py results/u3/compiler results/w1/compiler > results/symbols-u3-w1.txt 2>&1
for l in u3 w1; do echo "== $l"; nm -S results/$l/compiler | grep -i " node_facts_\| node_machine_\(type\|contexts\|expand\|classify\|own\|rule\)" | sort -k4; done > results/addresses-u3-w1.txt
echo "job29 done $(date -u +%FT%TZ)" >> $log
