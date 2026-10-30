#!/bin/bash
# #905: the final commit (7bfaee29), whose test-lanes adds sessions whose flow begins before lane 0 settles and a
# topology of fours: built, test-lanes and test-call-graph, then a TSan build's test-lanes and test-check-lanes; each
# under the lock alone. Waits for wrap11's run to finish first.
set -u
cd ~/buster-fast-bench/905-claude
echo $$ > wrap12.pid
while ! grep -q '^finished' logs/tests-percore-2.status 2>/dev/null; do sleep 10; done
lock=~/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=905-claude EXCLUSIVE_TITLE="#905 lanes per core (Claude)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/905
head=percore-3
status=$PWD/logs/tests-$head.status
(cd $head && BUSTER_DEBUG_INFO=0 $lock ./build.sh > ../logs/build-$head.log 2>&1); echo "build $?" > $status
cd $head
for t in "test-lanes" "test-check-lanes" "test-call-graph"; do
    name=$(echo "$t" | tr ' ' '_' | tr -d '/.' | cut -c1-60)
    $lock timeout 900 ./build/compiler $t > ../logs/$name-$head.log 2>&1
    echo "$t: $?" >> $status
done
$lock ./build.sh check-call-graph > ../logs/check-call-graph-$head.log 2>&1
echo "check-call-graph: $?" >> $status
cd ..
tsan=$head-tsan
(cd $tsan && BUSTER_SANITIZER=thread $lock ./build.sh > ../logs/build-$tsan.log 2>&1); echo "tsan build $?" >> $status
reports=$PWD/logs/tsan-reports-$head
rm -rf $reports
mkdir -p $reports
export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$(command -v llvm-symbolizer):log_path=$reports/report"
cd $tsan
for t in "test-lanes" "test-check-lanes"; do
    name=$(echo "$t" | tr ' ' '_' | tr -d '/.' | cut -c1-60)
    $lock timeout 600 ./build/compiler $t > ../logs/$name-$tsan.log 2>&1
    echo "tsan $t: $?" >> $status
done
cd ..
echo "tsan reports: $(ls $reports | wc -l)" >> $status
echo finished >> $status
