#!/usr/bin/env bash
# benchmark-backend-source on the frozen sqlite3.c's functions with the 9700X job's options, the first tree against
# the second, in one hold of the lock: 3 rounds, each tree once per round in an order alternated by round, on CPU 2.
# $1 and $2: the trees.
set -uo pipefail
a="$1"
b="$2"
dir="$HOME/buster-fast-bench/merged-759-780-claude"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
cd "$dir" || exit 1
echo "date $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "lock $(head -1 /var/lib/buster-9700x/owner 2>/dev/null)"
echo "trees $a $(cat "$a/COMMIT") $b $(cat "$b/COMMIT")"
for round in 1 2 3; do
    if [ $((round % 2)) -eq 1 ]; then order="$a $b"; else order="$b $a"; fi
    for tree in $order; do
        echo "=== round $round $tree"
        taskset -c 2 "./$tree/build/compiler" benchmark-backend-source "${source[@]}"
        echo "=== round $round $tree status $?"
    done
done
echo done
