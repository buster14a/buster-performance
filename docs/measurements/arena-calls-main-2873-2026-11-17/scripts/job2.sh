#!/bin/bash
# job2.sh: the piece on main with its start order made again (p2.patch), built as `main` was; then main against it, a
# hold of the lock an A/B (ab.sh), the tests on its build (tests.sh), the peaks, and abstat's table of each A/B.
cd "$(dirname "$0")"
main=c7caeb56b25c674dfe313edb28ee9ac8d728efe6
: > job2.done
./build-tree.sh p2 $main p2.patch > build-p2.out 2>&1
log=series.log
: > "$log"
mkdir -p results
for spec in sqlite:21 musl:5 hello:11 tiny:11 syntax:11 preprocess:11 command:5; do
    kind=${spec%%:*}
    rounds=${spec#*:}
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/ab-$kind" "$kind" "$rounds" "main=$PWD/main/build/compiler" "p2=$PWD/p2/build/compiler" > "results/ab-$kind.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $kind" >> "$log"
done
echo done >> "$log"
for kind in sqlite musl hello tiny syntax preprocess command; do tools/abstat "results/ab-$kind" main p2 > "results/abstat-$kind.txt" 2>&1; done
./tests.sh p2 results/tests-p2
./lock.sh timeout -k 10 900 ./peak.sh results/peak 11 "main=$PWD/main/build/compiler" "p2=$PWD/p2/build/compiler" > results/peak.log 2>&1
./lock.sh timeout -k 10 900 ./peak-empty.sh results/peak-empty 11 "main=$PWD/main/build/compiler" "p2=$PWD/p2/build/compiler" > results/peak-empty.log 2>&1
echo finished > job2.done
