#!/bin/bash
# After the rule's refit, with TREE the tree of the fitted rule (final4 if the fit keeps it; otherwise a tree built here
# from main MAIN with TREE.diff, whose deferred tests run first, into 4-tests-TREE.txt): campaign B4, the 43 units by
# main3's rule and TREE's on 8 lanes, five rounds, 11 jobs a lock hold (4-logB.txt); CT4, c-testsuite's 220 programs by
# both rules, three rounds, 20 programs a hold (4-logCT.txt); S4, which no refit changes, runs beside A4 (4-S4.sh).
# Each hold is a few minutes at most, as the lock asks. Arguments: MAIN TREE.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
echo $$ > "$D/4-chainB.pid"
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): item 2's rule against main's on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
tree="$2"
if [ "$tree" != final4 ]; then
    "$D/3-build.sh" "$1" "$tree" || { echo "chainB builds failed $(date -Is)" >> "$D/chain.out"; exit 1; }
    log="$D/4-tests-$tree.txt"
    for command in "./build/compiler test-checker-deferred" "./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 $D/c-testsuite/tests/single-exec"; do
        echo "== $(date -Is) $tree $command" >> "$log"
        (cd "$D/$tree" && ~/buster-fast-bench/exclusive.sh $command) >> "$log" 2>&1
        echo "exit=$? $(date -Is)" >> "$log"
    done
fi
sed "s/final4:8/$tree:8/" 4-jobsB.txt > 4-jobsB-$tree.txt
"$D/3-queue.sh" "4-jobsB-$tree.txt" 4-logB.txt 1 0 5 11 30
mapfile -t programs < <(grep -v "^#" "$D/main3/tests/c-testsuite/subset.txt" | grep -v "^$")
sed "s/final3/$tree/g" 3-batchCT.sh > 4-batchCT-$tree.sh && chmod +x 4-batchCT-$tree.sh
for round in 1 2 3; do
    for ((first = 0; first < ${#programs[@]}; first += 20)); do
        ~/buster-fast-bench/exclusive.sh "$D/4-batchCT-$tree.sh" "$D/4-logCT.txt" "$round" "${programs[@]:$first:20}" > /dev/null 2>> "$D/3-queue.lock.txt"
        sleep 30
    done
done
echo done >> "$D/4-logCT.txt"
echo "4-chainB done $(date -Is)" >> "$D/chain.out"
