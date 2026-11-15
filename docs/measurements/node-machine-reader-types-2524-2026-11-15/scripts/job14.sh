#!/bin/bash
# job14.sh: does #2867 slow #2850's fact words? m12 (main fdf0de745, which has #2863's kernel) and u1 (m12 with u1.patch:
# #2867's branch with that main merged in) built; the fact words' kernel by both on the three corpora, with the other
# session's facts.sh (buster-performance, per-core-step1-2850-2026-11-15) in its three window settings, the labels in
# turn, three runs each; -c sqlite3.c by both as whole processes from fresh copies of each executable, twice; and the
# executables' symbols compared.
set -u
cd "$(dirname "$0")"
log=results/job14.log
./build-label.sh m12 fdf0de745 > results/m12-build.out 2>&1 || { echo "m12 build failed" >> $log; exit 1; }
./build-label.sh u1 fdf0de745 u1.patch > results/u1-build.out 2>&1 || { echo "u1 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
for n in 1 2 3; do
    for label in m12 u1; do
        RUN=$n ./facts.sh $label "" 1 --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed" 1 --facts-packed --passes 5 --list 20 > /dev/null
    done
    echo "facts round $n done $(date -u +%T)" >> $log
done
python3 facts-tables.py results m12 u1 > results/facts-m12-u1.txt 2>&1
./ab-copies-n.sh m12 u1 2
echo "ab done $(date -u +%T)" >> $log
for n in 1 2 3; do
    for label in m12 u1; do
        RUN=$n ./facts.sh $label "-packed4096" 1 --facts-packed --facts-window 4096 --passes 5 --list 20 > /dev/null
    done
done
python3 facts-tables.py results m12 u1 > results/facts-m12-u1.txt 2>&1
python3 symdiff.py results/m12/compiler results/u1/compiler > results/symbols-m12-u1.txt
echo "job14 done $(date -u +%FT%TZ)" >> $log
