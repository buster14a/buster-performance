#!/bin/bash
# #1629, second part: ROUNDS (4) rounds of main418w, mainw and c7w, each round one lock hold, trees in an order that
# rotates by round, pinned to CPU 2, 101 passes: c-testsuite's 220 programs and the synthetic units, each run as the
# path is (cold) and with the object stage timed again warm after its Nth call (EMIT_AB_OBJECT_WARM=1..4: link_check,
# object_prepare, object_map_symbols, object_build); then the units' path (-c --lanes 1 of the 220 programs, twice,
# mainw and c7w).
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
LOCK=$HOME/buster-fast-bench/exclusive.sh
rounds=${1:-4}
until grep -q setup2-done setup2.log; do sleep 20; done
trees=(main418w mainw c7w)
units=(mainw c7w)
mkdir -p logs/rounds4 logs/units4
cat > round4.sh <<'INNER'
#!/bin/bash
cd ~/buster-fast-bench/1629-claude
r=$1; shift 1
for kind in c-testsuite synthetic; do
    if [ "$kind" = c-testsuite ]; then files=$(ls cts/tests/single-exec/*.c); else files=$(ls synthetic/*.c); fi
    for t in "$@"; do
        for w in cold 1 2 3 4; do
            if [ $w = cold ]; then
                taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds4/$kind-$w-round-$r-$t.txt 2> logs/rounds4/$kind-$w-round-$r-$t.err
            else
                EMIT_AB_OBJECT_WARM=$w taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds4/$kind-$w-round-$r-$t.txt 2> logs/rounds4/$kind-$w-round-$r-$t.err
            fi
            echo "$(date -u +%FT%TZ) $kind $w round $r $t exit=$? $(grep totals logs/rounds4/$kind-$w-round-$r-$t.txt | cut -c1-120)" >> logs/progress4.log
        done
    done
done
files=$(ls cts/tests/single-exec/*.c)
for pass in 1 2; do
    for t in $UNITS; do
        mkdir -p logs/units4/objects-$t
        rm -f logs/units4/objects-$t/*.o
        s=$(date +%s%N)
        (cd logs/units4/objects-$t && taskset -c 2 ../../../trees/$t/build/compiler -c --lanes 1 $(for f in $files; do echo ../../../$f; done) 2> /dev/null)
        st=$?
        e=$(date +%s%N)
        echo "round $r pass $pass tree $t exit=$st ns=$((e - s))" >> logs/units4/runs.txt
    done
done
INNER
chmod +x round4.sh
n=${#trees[@]}; m=${#units[@]}
for ((r = 1; r <= rounds; r++)); do
    order=(); for ((k = 0; k < n; k++)); do order+=(${trees[$(((k + r - 1) % n))]}); done
    uorder=(); for ((k = 0; k < m; k++)); do uorder+=(${units[$(((k + r - 1) % m))]}); done
    UNITS="${uorder[*]}" $LOCK ./round4.sh $r "${order[@]}"
    sleep 20
done
for t in "${units[@]}"; do
    echo "objects $t: $(ls logs/units4/objects-$t | wc -l) files, differ from mainw's: $(diff -rq logs/units4/objects-mainw logs/units4/objects-$t | wc -l)" >> logs/units4/runs.txt
done
echo rounds4-done >> logs/progress4.log
