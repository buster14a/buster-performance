#!/bin/bash
# #1629 on the 9700X, third set: builds c6 (the branch's head: c1 and the object writer's classes without atoms, 53854a7c..3d129eac)
# under the lock, then ROUNDS (4) rounds of main418, main, c1 and c6, as rounds.sh's: each round takes the shared lock once
# and runs every tree, in an order that rotates by round, pinned to CPU 2 with 101 passes: c-testsuite's 220 programs,
# then the synthetic units (benchmark-emit-ab), then the units' path (-c --lanes 1 of the 220 programs, twice per tree).
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
LOCK=$HOME/buster-fast-bench/exclusive.sh
rounds=${1:-4}
base=53854a7c2e5f9b2d48d73c967329597650943a42
for t in c6; do
    [ -x trees/$t/build/compiler ] || LOCK=$LOCK scripts/build-trees.sh buster.git trees $t=$base:now:$PWD/patches/$t.patch
done
ls -la trees/*/build/compiler
trees=(main418 main c1 c6)
units=(main c1 c6)
mkdir -p logs/rounds3-c-testsuite logs/rounds3-synthetic logs/units3
cat > round3.sh <<'INNER'
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
        taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds3-$kind/round-$r-$t.txt 2> logs/rounds3-$kind/round-$r-$t.err
        echo "$(date -u +%FT%TZ) $kind round $r $t exit=$? $(grep totals logs/rounds3-$kind/round-$r-$t.txt)" >> logs/progress3.log
    done
done
files=$(ls cts/tests/single-exec/*.c)
for pass in 1 2; do
    for t in $UNITS; do
        mkdir -p logs/units3/objects-$t
        rm -f logs/units3/objects-$t/*.o
        s=$(date +%s%N)
        (cd logs/units3/objects-$t && taskset -c 2 ../../../trees/$t/build/compiler -c --lanes 1 $(for f in $files; do echo ../../../$f; done) 2> /dev/null)
        st=$?
        e=$(date +%s%N)
        echo "round $r pass $pass tree $t exit=$st ns=$((e - s))" >> logs/units3/runs.txt
    done
done
INNER
chmod +x round3.sh
n=${#trees[@]}
m=${#units[@]}
for ((r = 1; r <= rounds; r++)); do
    order=()
    for ((k = 0; k < n; k++)); do order+=(${trees[$(((k + r - 1) % n))]}); done
    uorder=()
    for ((k = 0; k < m; k++)); do uorder+=(${units[$(((k + r - 1) % m))]}); done
    UNITS="${uorder[*]}" $LOCK ./round3.sh $r "${order[@]}"
    sleep 20
done
for t in "${units[@]}"; do
    echo "objects $t: $(ls logs/units3/objects-$t | wc -l) files, differ from main's: $(diff -rq logs/units3/objects-main logs/units3/objects-$t | wc -l)" >> logs/units3/runs.txt
done
echo rounds3-done >> logs/progress3.log
