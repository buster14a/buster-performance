#!/bin/bash
# annotate.sh TREE SYMBOL...: perf annotate of ab.sh's record of TREE (scratch/ab-TREE.data), each symbol into
# results/ab-annotate-TREE-SYMBOL.txt.
here=$(cd "$(dirname "$0")" && pwd)
tree=$1
shift
for symbol in "$@"; do
    perf annotate -i "$here/scratch/ab-$tree.data" --stdio -s "$symbol" 2> /dev/null > "$here/results/ab-annotate-$tree-$symbol.txt"
done
