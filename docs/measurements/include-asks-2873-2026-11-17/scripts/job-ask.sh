#!/bin/bash
# job-ask.sh: main (base) and main with the include search's asks (ask, files-ask.patch), each a Release build in one
# hold of the lock; their file system calls (counts.sh, in one hold); then base against ask, a hold of the lock an A/B
# (ab.sh: CPU 2, CPU-wide counts), and abstat's table of each.
cd "$(dirname "$0")"
main=d1cf1fe82879655f6149f0210e5d7ff5780e4a04
: > job-ask.done
./build-tree.sh base $main > build-base.out 2>&1
./build-tree.sh ask $main files-ask.patch > build-ask.out 2>&1
log=series.log
: > "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts "base=$PWD/base/build/compiler" "ask=$PWD/ask/build/compiler" > results/counts.log 2>&1
echo "$? counts" >> "$log"
for spec in hello:11 sqlite:21 musl:5 tiny:11 command:5 hello:11:again; do
    kind=${spec%%:*}
    rest=${spec#*:}
    rounds=${rest%%:*}
    label=$kind
    [ "$rest" != "$rounds" ] && label=$kind-${rest#*:}
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/ab-$label" "$kind" "$rounds" "base=$PWD/base/build/compiler" "ask=$PWD/ask/build/compiler" > "results/ab-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
done
echo done >> "$log"
for label in hello sqlite musl tiny command hello-again; do tools/abstat "results/ab-$label" base ask > "results/abstat-$label.txt" 2>&1; done
echo finished > job-ask.done
