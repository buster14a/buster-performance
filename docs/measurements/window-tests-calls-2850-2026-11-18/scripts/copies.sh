#!/bin/bash
# copies.sh N LABEL...: the front with the window on sqlite3.c (--front-window) from the build's own file and from N
# fresh copies of it (cp, so other pages of the page cache), each run its own hold of the lock, CPU 2, twice round.
# Prints the front's ticks of each run; files results/LABEL/copies-<name>-<round>.txt.
cd "$(dirname "$0")"
. ./corpora.sh
n=$1; shift
for label in "$@"; do
    out=$PWD/results/$label
    for i in $(seq 1 "$n"); do cp "$out/compiler" "$out/compiler-copy-$i"; done
    for round in 1 2; do
        for name in compiler $(for i in $(seq 1 "$n"); do echo compiler-copy-$i; done); do
            f=$out/copies-$name-$round.txt
            ./lock.sh bash -c "taskset -c 2 $out/$name measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments; echo status \$?" > "$f" 2>&1
            echo "$label $name round $round: front $(grep -o 'the front with the window: ticks=[0-9]*' "$f" | grep -o '[0-9]*$') plain $(grep -o 'the same front without it, on the same chunks: ticks=[0-9]*' "$f" | grep -o '[0-9]*$') kernel $(grep -o 'the kernel in place: .* ticks=[0-9]*' "$f" | grep -o '[0-9]*$')"
        done
    done
    for i in $(seq 1 "$n"); do rm -f "$out/compiler-copy-$i"; done
done
echo copies done
