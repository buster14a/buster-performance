#!/bin/bash
# job-gat3.sh REVISION: the sweep piece on main REVISION (gat3: sweep-main.diff, the piece's sources) on the 9700X: its
# Release build and test-checker's eight parts in its tree, with the toolchain's clang for the oracle's builds; and
# C on the window on the three corpora, once each, for its count lines. Each run its own hold of the lock.
cd "$(dirname "$0")"
bench=$PWD
./build-label.sh gat3 "$1" sweep-main.diff || exit 1
out=$bench/results/gat3
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
. ./corpora.sh
for c in sqlite3 lua musl; do
    case $c in
        sqlite3) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
        musl) arguments=$musl_arguments ;;
    esac
    for label in gat3 main3030; do
        ./lock.sh bash -c "taskset -c 2 $bench/results/$label/compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments; echo status \$?" > "$out/counts-$label-$c.txt" 2>&1
    done
done
cd "$bench/trees/gat3" || exit 1
mkdir -p build
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
: > "$out/status.txt"
for p in 1 2 3 4 5 6 7 8; do
    start=$(date +%s)
    "$bench/lock.sh" bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $out/compiler test-checker --seed 133 --part $p/8 2> $out/part$p.err; echo status \$?" > "$out/part$p.out" 2>&1
    echo "part $p $(tail -1 "$out/part$p.out"); wall $(( $(date +%s) - start )) s; $(grep 'test-checker:.*checks' "$out/part$p.out" | tail -1)" >> "$out/status.txt"
done
echo job finished
