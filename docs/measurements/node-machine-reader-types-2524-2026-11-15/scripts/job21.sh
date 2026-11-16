#!/bin/bash
# job21.sh: #2867 against main's fact words once more, after main gained buster#2868 (a lookup's lean record, and its
# load alone). m14 (main be6515fba) and u3 (it with #2867's branch merged, u3.patch = be6515fba..084b3facb) built; the
# fact words' three kernels (whole, lean, loads) by both on sqlite3.c, Lua and musl, a body a window and packed to 384
# records (the follow-up's record's settings), and the whole kernel packed to 4,096; the labels in turn, three rounds;
# the kernels' functions' addresses; then -c sqlite3.c as whole processes from fresh copies, twice.
set -u
cd "$(dirname "$0")"
log=results/job21.log
./build-label.sh m14 be6515fba > results/m14-build.out 2>&1 || { echo "m14 build failed" >> $log; exit 1; }
./build-label.sh u3 be6515fba u3.patch > results/u3-build.out 2>&1 || { echo "u3 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
for n in 1 2 3; do
    for label in m14 u3; do
        RUN=$n ./facts.sh $label "" 1 --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-lean" 1 --facts-lean --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loads" 1 --facts-loads --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed" 1 --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-leanpacked" 1 --facts-lean --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loadspacked" 1 --facts-loads --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed4096" 1 --facts-packed --facts-window 4096 --passes 5 --list 20 > /dev/null
    done
    echo "facts round $n done $(date -u +%T)" >> $log
    python3 facts-tables2.py results m14 u3 > results/facts-m14-u3.txt 2>&1
done
for l in m14 u3; do echo "== $l"; nm -S results/$l/compiler | grep -i " node_facts_" | sort -k4; done > results/facts-addresses-m14-u3.txt
./ab-copies-n.sh m14 u3 2 > results/ab-m14-u3.out 2>&1
echo "ab done $(date -u +%T)" >> $log
python3 symdiff.py results/m14/compiler results/u3/compiler > results/symbols-m14-u3.txt 2>&1
echo "job21 done $(date -u +%FT%TZ)" >> $log
