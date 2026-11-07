#!/bin/bash
# #1629 on the 9700X, second set: builds c4 (c3 with the runtime names' home buckets prefetched) and c5 (c4 without the
# home-bucket probes, f1f738a3), each in a lock hold of its own, then ROUNDS (4) rounds of main418, main, c1, c3, c4 and c5. Each round takes the shared lock once and runs every tree, in an order
# that rotates by round, pinned to CPU 2 with 101 passes: c-testsuite's 220 programs, then the synthetic units
# (benchmark-emit-ab), then the units' path (-c --lanes 1 of the 220 programs, twice per tree that has it).
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
LOCK=$HOME/buster-fast-bench/exclusive.sh
rounds=${1:-4}
base=53854a7c2e5f9b2d48d73c967329597650943a42
for t in c4 c5; do
    [ -x trees/$t/build/compiler ] || LOCK=$LOCK scripts/build-trees.sh buster.git trees $t=$base:now:$PWD/patches/$t.patch
done
ls -la trees/*/build/compiler
trees=(main418 main c1 c3 c4 c5)
units=(main c3 c4 c5)
mkdir -p logs/rounds2-c-testsuite logs/rounds2-synthetic logs/units2
cat > round2.sh <<'INNER'
#!/bin/bash
# One round: ROUND, then the trees in this round's order; UNITS the units' trees in this round's order.
cd ~/buster-fast-bench/1629-claude
r=$1; shift 1
for kind in c-testsuite synthetic; do
    if [ "$kind" = c-testsuite ]; then
        files=$(ls cts/tests/single-exec/*.c)
    else
        files=$(ls synthetic/*.c)
    fi
    for t in "$@"; do
        taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds2-$kind/round-$r-$t.txt 2> logs/rounds2-$kind/round-$r-$t.err
        echo "$(date -u +%FT%TZ) $kind round $r $t exit=$? $(grep totals logs/rounds2-$kind/round-$r-$t.txt)" >> logs/progress2.log
    done
done
files=$(ls cts/tests/single-exec/*.c)
for pass in 1 2; do
    for t in $UNITS; do
        mkdir -p logs/units2/objects-$t
        rm -f logs/units2/objects-$t/*.o
        s=$(date +%s%N)
        (cd logs/units2/objects-$t && taskset -c 2 ../../../trees/$t/build/compiler -c --lanes 1 $(for f in $files; do echo ../../../$f; done) 2> /dev/null)
        st=$?
        e=$(date +%s%N)
        echo "round $r pass $pass tree $t exit=$st ns=$((e - s))" >> logs/units2/runs.txt
    done
done
INNER
chmod +x round2.sh
n=${#trees[@]}
m=${#units[@]}
for ((r = 1; r <= rounds; r++)); do
    order=()
    for ((k = 0; k < n; k++)); do order+=(${trees[$(((k + r - 1) % n))]}); done
    uorder=()
    for ((k = 0; k < m; k++)); do uorder+=(${units[$(((k + r - 1) % m))]}); done
    UNITS="${uorder[*]}" $LOCK ./round2.sh $r "${order[@]}"
    sleep 20
done
for t in "${units[@]}"; do
    echo "objects $t: $(ls logs/units2/objects-$t | wc -l) files, differ from main's: $(diff -rq logs/units2/objects-main logs/units2/objects-$t | wc -l)" >> logs/units2/runs.txt
done
echo rounds2-done >> logs/progress2.log
