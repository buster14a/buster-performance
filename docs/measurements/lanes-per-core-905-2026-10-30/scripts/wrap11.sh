#!/bin/bash
# #905: one lane per core, rebased onto main b424fe30 (#924's LaneFlow): the suites and a TSan build's, then main against
# the head (time-runs, --time-stages, link-foreign's benchmark, the core count's cost); each build, test and
# measurement under the lock alone. Waits for wrap10's run to finish first.
set -u
cd ~/buster-fast-bench/905-claude
echo $$ > wrap11.pid
while ! grep -q finished logs/tests-percore-1.status 2>/dev/null; do sleep 10; done
lock=~/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=905-claude EXCLUSIVE_TITLE="#905 lanes per core (Claude)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/905
head=percore-2
main=main-b424fe30
status=$PWD/logs/tests-$head.status
(cd $head && BUSTER_DEBUG_INFO=0 $lock ./build.sh > ../logs/build-$head.log 2>&1); echo "build $?" > $status
cd $head
$lock ./build.sh check-call-graph > ../logs/check-call-graph-$head.log 2>&1
echo "check-call-graph: $?" >> $status
for t in "test-lanes" "test-check-lanes" "test-check-units" "test-checker-driver --executable ./build/compiler" "test-foreign --cross-check" "test-parallel" "test-call-graph" "test-c-testsuite --self-test"; do
    name=$(echo "$t" | tr ' ' '_' | tr -d '/.' | cut -c1-60)
    $lock timeout 900 ./build/compiler $t > ../logs/$name-$head.log 2>&1
    echo "$t: $?" >> $status
done
cd ..
tsan=$head-tsan
(cd $tsan && BUSTER_SANITIZER=thread $lock ./build.sh > ../logs/build-$tsan.log 2>&1); echo "tsan build $?" >> $status
reports=$PWD/logs/tsan-reports-$head
rm -rf $reports
mkdir -p $reports
(
    export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$(command -v llvm-symbolizer):log_path=$reports/report"
    cd $tsan
    for t in "test-lanes" "test-check-lanes" "test-checker-driver --executable ./build/compiler" "test-foreign --cross-check"; do
        name=$(echo "$t" | tr ' ' '_' | tr -d '/.' | cut -c1-60)
        $lock timeout 600 ./build/compiler $t > ../logs/$name-$tsan.log 2>&1
        echo "tsan $t: $?" >> $status
    done
    $lock timeout 600 taskset -c 0-3 ./build/compiler test-check-units > ../logs/test-check-units-$tsan.log 2>&1
    echo "tsan test-check-units CPUs 0-3: $?" >> $status
)
echo "tsan reports: $(ls $reports | wc -l)" >> $status
echo "tests finished" >> $status

# The measurements.
(cd $main && BUSTER_DEBUG_INFO=0 $lock ./build.sh > ../logs/build-$main.log 2>&1); echo "build $main $?" >> $status
mkdir -p out
sqlite=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c
# name|cpus|time-runs lists
cases=(
    "sqlite-c-all|all|--list -c $sqlite -o out/sqlite.o"
    "sqlite-c-4cores|0-3,8,9,11|--list -c $sqlite -o out/sqlite.o"
    "small-c-all|all|--list -c inputs/small.c -o out/small.o"
    "small-link-all|all|--list inputs/small.c -o out/small"
    "units-c-all|all|--list -c inputs/a.c inputs/b.c inputs/c.c inputs/d.c"
)
for round in 1 2 3; do
    for entry in "${cases[@]}"; do
        IFS='|' read -r name cpus lists <<< "$entry"
        pin=()
        if [ "$cpus" != all ]; then
            pin=(taskset -c "$cpus")
        fi
        runs=21
        case "$name" in sqlite*) runs=11 ;; esac
        # shellcheck disable=SC2086 # the lists are words
        "$lock" "${pin[@]}" $head/build/compiler time-runs --runs "$runs" --warmups 2 \
            --build main $main/build/compiler --build head $head/build/compiler $lists > "logs/percore-$name-$round.log" 2>&1
        echo "time-runs $name round $round: $?" >> $status
    done
done
for i in 1 2 3; do
    for t in $main $head; do
        $lock $t/build/compiler --time-stages -c $sqlite -o out/s-$t.o 2> logs/percore-stages-$t-$i.txt
        $lock taskset -c 0-3,8,9,11 $t/build/compiler --time-stages -c $sqlite -o out/s-$t.o 2> logs/percore-stages-4cores-$t-$i.txt
    done
done
echo "stages done" >> $status
for i in 1 2; do
    for t in $main $head; do
        $lock $t/build/compiler benchmark-link --only linkers --linkers link-foreign --kinds dynamic,static --functions 1,2000 > logs/percore-link-$t-$i.log 2>&1
        echo "benchmark-link $t $i: $?" >> $status
    done
done
cc -O2 -o out/cores_cost cores_cost.c
for i in 1 2 3; do
    $lock out/cores_cost o >> logs/percore-cores-cost.log 2>&1
    $lock taskset -c 0-3,8,9,11 out/cores_cost o >> logs/percore-cores-cost.log 2>&1
done
echo finished >> $status
