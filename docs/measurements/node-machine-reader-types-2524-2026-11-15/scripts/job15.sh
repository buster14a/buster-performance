#!/bin/bash
# job15.sh: is job14's difference the kernel's code's place? m13 (main fdf0de745 with align.patch: the fact words' eight
# kernel functions aligned to 64 bytes) and u2 (m13 with #2867's branch merged, u2.patch) built; the fact words' kernel
# by both on sqlite3.c, Lua and musl in the three window settings, the labels in turn, three runs each, with the first
# pair (m12, u1) run again beside them.
set -u
cd "$(dirname "$0")"
log=results/job15.log
./build-label.sh m13 fdf0de745 align.patch > results/m13-build.out 2>&1 || { echo "m13 build failed" >> $log; exit 1; }
./build-label.sh u2 fdf0de745 u2.patch > results/u2-build.out 2>&1 || { echo "u2 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
for n in 4 5 6; do
    for label in m13 u2 m12 u1; do
        RUN=$n ./facts.sh $label "" 1 --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed" 1 --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed4096" 1 --facts-packed --facts-window 4096 --passes 5 --list 20 > /dev/null
    done
    echo "facts round $n done $(date -u +%T)" >> $log
done
python3 facts-tables.py results m13 u2 > results/facts-m13-u2.txt 2>&1
python3 facts-tables.py results m12 u1 > results/facts-m12-u1-six.txt 2>&1
for l in m12 u1 m13 u2; do echo "== $l"; nm results/$l/compiler | grep -i " node_facts_\(window\|leaves\|arrows\|dots\|subscripts\|calls\|discards\|slow\)$" | sort -k3; done > results/facts-addresses.txt
echo "job15 done $(date -u +%FT%TZ)" >> $log
