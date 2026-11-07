#!/bin/bash
# #442 phase C on the 9700X: the record's rounds with fix3 and fix4 (this work's head after review: fix3 and the units'
# lanes keeping lane 0's columns through check_driver_object). Builds fix4 first, under the lock. Each round takes the
# shared lock once, for a minute or two, and runs every tree in an order that rotates by round, each run pinned to CPU 2 with 101 passes: c-testsuite's 220
# programs, then the synthetic units (benchmark-emit-ab), then the units' path (-c --lanes 1 of the 220 programs, twice
# per tree that has it). Usage: phaseC.sh ROUNDS (4)
cd ~/buster-fast-bench/442-claude-rebase
export EXCLUSIVE_OWNER=claude-442 EXCLUSIVE_TITLE="Solve 442" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/442
LOCK=$HOME/buster-fast-bench/exclusive.sh
rounds=4
trees=(main418 pr418 now fix1 fix2 fix3 fix4)
units=(now fix3 fix4)
[ -x trees/fix4/build/compiler ] || LOCK=$LOCK scripts/build-trees.sh buster.git trees fix4=ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b:now:$PWD/patches/fix4.patch
mkdir -p logs-c/rounds-c-testsuite logs-c/rounds-synthetic logs-c/units
cat > round-c.sh <<'INNER'
#!/bin/bash
# One round: ROUND, then the trees in this round's order; UNITS the units' trees in this round's order.
cd ~/buster-fast-bench/442-claude-rebase
r=$1; shift 1
for kind in c-testsuite synthetic; do
    if [ "$kind" = c-testsuite ]; then
        files=$(ls cts/tests/single-exec/*.c)
    else
        files=$(ls synthetic/*.c)
    fi
    for t in "$@"; do
        taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs-c/rounds-$kind/round-$r-$t.txt 2> logs-c/rounds-$kind/round-$r-$t.err
        echo "$(date -u +%FT%TZ) $kind round $r $t exit=$? $(grep totals logs-c/rounds-$kind/round-$r-$t.txt)" >> logs-c/progress.log
    done
done
files=$(ls cts/tests/single-exec/*.c)
for pass in 1 2; do
    for t in $UNITS; do
        mkdir -p logs-c/units/objects-$t
        rm -f logs-c/units/objects-$t/*.o
        s=$(date +%s%N)
        (cd logs-c/units/objects-$t && taskset -c 2 ../../../trees/$t/build/compiler -c --lanes 1 $(for f in $files; do echo ../../../$f; done) 2> /dev/null)
        st=$?
        e=$(date +%s%N)
        echo "round $r pass $pass tree $t exit=$st ns=$((e - s))" >> logs-c/units/runs.txt
    done
done
INNER
chmod +x round-c.sh
n=${#trees[@]}
m=${#units[@]}
for ((r = 1; r <= rounds; r++)); do
    order=()
    for ((k = 0; k < n; k++)); do order+=(${trees[$(((k + r - 1) % n))]}); done
    uorder=()
    for ((k = 0; k < m; k++)); do uorder+=(${units[$(((k + r - 1) % m))]}); done
    UNITS="${uorder[*]}" $LOCK ./round-c.sh $r "${order[@]}"
    sleep 20
done
for t in "${units[@]}"; do
    echo "objects $t: $(ls logs-c/units/objects-$t | wc -l) files, differ from now's: $(diff -rq logs-c/units/objects-now logs-c/units/objects-$t | wc -l)" >> logs-c/units/runs.txt
done
echo phaseC-done >> logs-c/progress.log
