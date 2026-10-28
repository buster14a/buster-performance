#!/usr/bin/env bash
# #148's alloca and frame builtins: -c of the frozen sqlite3.c (CI's compile-time options), the merge-base against the
# head, in one hold of the lock: a drive check of each (status and object), then 8 rounds of perf stat -r 3 on CPU 2, the
# order alternated by round. $1 and $2: the trees (base and head).
set -uo pipefail
a="${1:-base}"
b="${2:-head}"
dir="$HOME/buster-fast-bench/alloca-frame-148-claude"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$dir" || exit 1
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
for tree in "$a" "$b"; do
    taskset -c 2 "./$tree/build/compiler" "${options[@]}" -o "$dir/$tree.o"
    echo "drive $tree status $?"
done
cmp "$a.o" "$b.o" && echo "objects identical"
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) -eq 1 ]; then order="$a $b"; else order="$b $a"; fi
    for tree in $order; do
        perf stat -x, -e instructions:u,cycles:u,task-clock -r 3 taskset -c 2 "./$tree/build/compiler" "${options[@]}" -o "$dir/$tree-run.o" 2>&1 >/dev/null |
            grep -E 'instructions|cycles|task-clock' | sed "s/^/round $round $tree,/"
    done
done
# Tier 0's own benchmark on the functions -c compiles of the same file (CI's options), two rounds, the order swapped.
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for round in 1 2; do
    if [ "$round" -eq 1 ]; then order="$a $b"; else order="$b $a"; fi
    for tree in $order; do
        echo "backend-source round $round $tree"
        (unset CPATH C_INCLUDE_PATH; SOURCE_DATE_EPOCH=1792454400 taskset -c 2 "./$tree/build/compiler" benchmark-backend-source "${source[@]}") > "backend-$round-$tree.log" 2>&1
        echo "status $?"
    done
done
echo done
