#!/bin/bash
# series-p2.sh: the pull request's head (head -> ../p1/full) against piece 2 (`full` here, built from the patches), a hold
# of the lock an A/B (ab.sh), then the tests on piece 2's build.
cd "$(dirname "$0")"
./build-tree.sh full 1c6cc8ab5e778ab32078cbef17049c4814b30dca tool.patch huge.patch list.patch > build-full.out 2>&1
log=series-p2.log
: > "$log"
for spec in sqlite:21 musl:5 hello:11 tiny:11 syntax:11 preprocess:11 command:5; do
    kind=${spec%%:*}
    rounds=${spec#*:}
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/ab-$kind" "$kind" "$rounds" "head=$PWD/head/build/compiler" "p2=$PWD/full/build/compiler" > "results/ab-$kind.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $kind" >> "$log"
done
echo done >> "$log"
./tests.sh full results/tests-p2
echo finished > series-p2.done
