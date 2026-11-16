#!/bin/bash
# series.sh NAME TREE...: main against each TREE, a hold of the lock an A/B (ab.sh): sqlite3.c (21 rounds), musl a unit
# a process (5), the four small commands (11 each) and musl as one command (5). results/NAME-TREE-KIND; series-NAME.log
# has each A/B's status and seconds.
cd "$(dirname "$0")"
name=$1
shift
log=series-$name.log
: > "$log"
for tree in "$@"; do
    for spec in sqlite:21 musl:5 syntax:11 preprocess:11 tiny:11 hello:11 command:5; do
        kind=${spec%%:*}
        rounds=${spec#*:}
        start=$(date +%s)
        ./lock.sh timeout -k 10 900 ./ab.sh "results/$name-$tree-$kind" "$kind" "$rounds" "main=$PWD/main/build/compiler" "$tree=$PWD/$tree/build/compiler" > "results/$name-$tree-$kind.log" 2>&1
        echo "$? $(( $(date +%s) - start ))s $tree $kind" >> "$log"
    done
done
echo done >> "$log"
