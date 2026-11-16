#!/bin/bash
# job40.sh: the tests where they sit, on the pull request's sources. z3 (main be6515fba with z3.patch) built; the shadow
# on sqlite3.c and Lua seven times and on musl three times, the specs in turn: T, C and X at reader time and the same
# with the census's tests between T and C, with the whole front and with the lean one, and the shadow's own sweeps by w2
# (the parent: C and X where they sit at that main) and by z3 in seven passes (one on musl); one run of each corpus with
# every warning on and --verify, for the counts; -c sqlite3.c by w2 and z3 as whole processes from fresh copies, twice;
# the executables' symbols compared; and the fact words' kernels by both, runs 19 to 24, as job21 ran them.
set -u
cd "$(dirname "$0")"
log=results/job40.log
while systemctl --user is-active -q claude-2524-job39; do sleep 20; done
./build-label.sh z3 be6515fba z3.patch > results/z3-build.out 2>&1 || { echo "z3 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./types-o2.sh -f 1 7 "z3 sweeps --front-sweeps --passes 1" "z3 tests --front-tests --passes 1" "z3 leansweeps --front-lean --front-sweeps --passes 1" "z3 leantests --front-lean --front-tests --passes 1" "w2 plain7 --passes 7" "z3 plain7 --passes 7" || { echo "types-o2 failed" >> $log; exit 1; }
test -s results/z3/types-plain7-sqlite3-f-7.txt || { echo "types-o2 made no files" >> $log; exit 1; }
echo "types done $(date -u +%T)" >> $log
./types-o2.sh -wall 1 1 "z3 walltests --front-tests --verify --passes 1 -Wall -Wextra" "z3 verifytests --front-tests --verify --passes 1"
./types-musl-o.sh -f 3 "z3 sweeps --front-sweeps --passes 1" "z3 tests --front-tests --passes 1" "z3 leantests --front-lean --front-tests --passes 1" "w2 plain1 --passes 1" "z3 plain1 --passes 1" || { echo "musl failed" >> $log; exit 1; }
./types-musl-o.sh -wall 1 "z3 walltests --front-tests --verify --passes 1 -Wall -Wextra" "z3 verifytests --front-tests --verify --passes 1"
echo "musl done $(date -u +%T)" >> $log
./ab-copies-n.sh w2 z3 2 > results/ab-w2-z3.out 2>&1
echo "ab done $(date -u +%T)" >> $log
python3 symdiff.py results/w2/compiler results/z3/compiler > results/symbols-w2-z3.txt 2>&1
for l in w2 z3; do echo "== $l"; nm -S results/$l/compiler | grep -i " node_facts_\| node_machine_\(type\|contexts\|expand\|classify\|own\|rule\|update_plan\|number_labels\)" | sort -k4; done > results/addresses-w2-z3.txt
for n in 19 20 21 22 23 24; do
    for label in w2 z3; do
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
echo "job40 done $(date -u +%FT%TZ)" >> $log
