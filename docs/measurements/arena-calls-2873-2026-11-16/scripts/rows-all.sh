#!/bin/bash
# rows-all.sh: rows.sh for main, the pull request's head and piece 2, on sqlite3.c and on musl a unit a process, with the
# harness's own for musl. Waits for final-p2.sh by its file. A hold of the lock each.
cd "$(dirname "$0")"
true
: > rows.done
for kind in sqlite musl; do
    for tree in main head full; do
        ./lock.sh timeout -k 10 600 ./rows.sh "$tree-$kind" "$PWD/$tree/build/compiler" "$kind" > "results/rows-$tree-$kind.log" 2>&1
    done
done
./lock.sh timeout -k 10 600 ./rows.sh true-musl /usr/bin/true musl > results/rows-true-musl.log 2>&1
echo finished > rows.done
