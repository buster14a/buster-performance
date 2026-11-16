#!/bin/bash
# shadow.sh LABEL: the node machine's census and shadow (measure-node-machine --shadow --list 20) by results/LABEL/compiler
# on sqlite3.c, Lua and musl, CPU 2, each its own hold of the lock. A count: nothing is timed. It shows what the lowering's
# change leaves the node machine (buster#2883's question to its holder). results/LABEL/shadow-CORPUS.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1
out=$PWD/results/$label
for name in sqlite3 lua musl; do
    options=$(corpus_options "$name")
    files=$(corpus_files "$name" | while read -r f; do printf '%q ' "$f"; done)
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; taskset -c 2 $out/compiler measure-node-machine --shadow --list 20 $options $files | grep -v '^node-census: file='; echo status \${PIPESTATUS[0]}" > "$out/shadow-$name.txt" 2>&1
done
echo done
