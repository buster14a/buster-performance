#!/bin/bash
# run1.sh: main 968a085f + experiment.diff (compiler-exp). 1) --tier1 -c of sqlite3.c, Lua, musl with the frame path forced
# scalar (BUSTER_FRAME_SCALAR=1) and vector (=2): objects compared; the vector run dumps every frame request (dumps/LIST.bin).
# 2) benchmark-tier1-frame --replay of each dump (every real frame planned once a pass, both paths, by size bin), 3 rounds.
# 3) the in-compile probe: frame planning's ticks by size bin, each path, 3 rounds. 4) the synthetic benchmark by --count.
# Each step is its own locked run, on CPU 2 where timed.
set -uo pipefail
cd "$(dirname "$0")"; D=$PWD
export EXCLUSIVE_OWNER=claude-2924-frame EXCLUSIVE_TITLE="buster #2924/#2699: Tier 1 frame colorer twin" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2699
L=~/buster-fast-bench/exclusive.sh
E=$D/compiler-exp
mkdir -p logs dumps
O=/dev/shm/claude-2924-frame
rm -rf $O dumps/*.bin
BUSTER_FRAME_SCALAR=1 $L timeout -k 5 600 ./objects.sh $E $O/scalar > logs/objects-scalar.log 2>&1
BUSTER_FRAME_SCALAR=2 DUMPDIR=$D/dumps $L timeout -k 5 600 ./objects.sh $E $O/vector > logs/objects-vector.log 2>&1
(cd $O/scalar && find . -name '*.o' | sort) > logs/objects-list.txt
n=0; d=0
while read -r f; do n=$((n+1)); cmp -s "$O/scalar/$f" "$O/vector/$f" || { d=$((d+1)); echo "differs: $f" >> logs/objects-compare.txt; }; done < logs/objects-list.txt
echo "objects: $n compared, $d differ" > logs/objects-summary.txt
ls -l dumps >> logs/objects-summary.txt
for round in 1 2 3; do
    for list in sqlite lua musl; do
        $L timeout -k 5 600 taskset -c 2 $E benchmark-tier1-frame --replay dumps/$list.bin > logs/replay-$list-$round.log 2>&1
    done
done
for round in 1 2 3; do
    for path in 1 2; do
        rm -rf $O/p
        ERR=$D/logs/probe-$path-$round BUSTER_FRAME_SCALAR=$path BUSTER_FRAME_PROBE=0 $L timeout -k 5 600 taskset -c 2 ./objects.sh $E $O/p > logs/probe-$path-$round.log 2>&1
        for list in sqlite lua musl; do grep FRAMEPROBE logs/probe-$path-$round-$list | tail -1 > logs/probe-$path-$round-$list.last; rm -f logs/probe-$path-$round-$list; done
    done
done
for round in 1 2; do
    $L timeout -k 5 600 bash -c 'for n in 1 2 3 4 6 8 12 16 24 32 48 64; do echo "count $n"; taskset -c 2 '$E' benchmark-tier1-frame --phase total --count $n; done' > logs/synthetic-small-$round.log 2>&1
    $L timeout -k 5 600 bash -c 'for n in 128 256 1024 4096 32768; do echo "count $n"; taskset -c 2 '$E' benchmark-tier1-frame --phase total --count $n; done' > logs/synthetic-large-$round.log 2>&1
done
rm -rf $O
date -u +%FT%TZ > logs/run1.done
