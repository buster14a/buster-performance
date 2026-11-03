#!/bin/bash
# usage: repeat-remote.sh OUT N CONFIG TREE...  (on benchpress): per tree, one locked run of the benchmark with
# BUSTER_PP_PRINT_REPEAT=N (the local harness), --only vectorized; CONFIG mainP|mainE|sqliteP|sqliteE.
out=~/buster-fast-bench/649-claude/out/"$1"; n="$2"; config="$3"; shift 3
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
src=~/buster-fast-bench/649-claude/base/src
case $config in
    main*) args="-target x86_64-pc-linux-gnu -march=native -I$src -fwrapv -funsigned-char $src/buster/compiler/main.c" ;;
    *) args="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c" ;;
esac
markers=""; [[ $config == *E ]] && markers="--markers"
for tree in "$@"; do
    cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
    EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 print repeats" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
        ~/buster-fast-bench/exclusive.sh bash -c "unset CPATH C_INCLUDE_PATH; BUSTER_PP_PRINT_REPEAT=$n taskset -c 2 ./build/compiler benchmark-preprocessor --only vectorized $markers $args" \
        > "$out/$config.$tree.txt" 2>&1
done
echo done > "$out/done.$config"
