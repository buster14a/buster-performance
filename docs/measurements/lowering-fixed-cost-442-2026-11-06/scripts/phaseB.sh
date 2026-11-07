#!/bin/bash
# #442 phase B on the 9700X: the record's rounds. Each round takes the shared lock once, for about half a minute, and
# runs every tree in an order that rotates by round, each run pinned to CPU 2 with 101 passes: c-testsuite's 220 programs
# (benchmark-emit-ab), then the units' path (-c --lanes 1 of the 220 programs, twice per tree that has it). Then the
# synthetic units' rounds, one hold each. Usage: phaseB.sh ROUNDS SYNTHETIC_ROUNDS
cd ~/buster-fast-bench/442-claude-rebase
export EXCLUSIVE_OWNER=claude-442 EXCLUSIVE_TITLE="Solve 442" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/442
LOCK=$HOME/buster-fast-bench/exclusive.sh
rounds=${1:-6}
synthetic_rounds=${2:-4}
trees=(main418 pr418 now fix1 fix2)
units=(now fix1 fix2)
mkdir -p logs/rounds-c-testsuite logs/rounds-synthetic logs/units
cat > round.sh <<'INNER'
#!/bin/bash
# One round: KIND (c-testsuite or synthetic), ROUND, then the trees in this round's order; UNITS the units' trees.
cd ~/buster-fast-bench/442-claude-rebase
kind=$1; r=$2; shift 2
if [ "$kind" = c-testsuite ]; then
    files=$(ls cts/tests/single-exec/*.c)
else
    files=$(ls synthetic/*.c)
fi
for t in "$@"; do
    taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds-$kind/round-$r-$t.txt 2> logs/rounds-$kind/round-$r-$t.err
    echo "$(date -u +%FT%TZ) $kind round $r $t exit=$? $(grep totals logs/rounds-$kind/round-$r-$t.txt)" >> logs/progress.log
done
if [ "$kind" = c-testsuite ]; then
    for pass in 1 2; do
        for t in $UNITS; do
            mkdir -p logs/units/objects-$t
            rm -f logs/units/objects-$t/*.o
            s=$(date +%s%N)
            (cd logs/units/objects-$t && taskset -c 2 ../../../trees/$t/build/compiler -c --lanes 1 $(for f in $files; do echo ../../../$f; done) 2> /dev/null)
            st=$?
            e=$(date +%s%N)
            echo "round $r pass $pass tree $t exit=$st ns=$((e - s))" >> logs/units/runs.txt
        done
    done
fi
INNER
chmod +x round.sh
n=${#trees[@]}
for ((r = 1; r <= rounds; r++)); do
    order=()
    for ((k = 0; k < n; k++)); do order+=(${trees[$(((k + r - 1) % n))]}); done
    m=${#units[@]}
    uorder=()
    for ((k = 0; k < m; k++)); do uorder+=(${units[$(((k + r - 1) % m))]}); done
    UNITS="${uorder[*]}" $LOCK ./round.sh c-testsuite $r "${order[@]}"
    sleep 20
done
for ((r = 1; r <= synthetic_rounds; r++)); do
    order=()
    for ((k = 0; k < n; k++)); do order+=(${trees[$(((k + r - 1) % n))]}); done
    UNITS= $LOCK ./round.sh synthetic $r "${order[@]}"
    sleep 20
done
for t in "${units[@]}"; do
    echo "objects $t: $(ls logs/units/objects-$t | wc -l) files, differ from now's: $(diff -rq logs/units/objects-now logs/units/objects-$t | wc -l)" >> logs/units/runs.txt
done
echo phaseB-done >> logs/progress.log
