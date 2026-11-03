#!/bin/bash
# round.sh OUT ROUND TREE...: one round, run inside the lock.
out="$1"; round="$2"; shift 2
unset CPATH C_INCLUDE_PATH
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
src=~/buster-fast-bench/649-claude/base/src
main_args="-target x86_64-pc-linux-gnu -march=native -I$src -fwrapv -funsigned-char $src/buster/compiler/main.c"
sqlite_args="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for config in mainP mainE sqliteP sqliteE; do
    case $config in main*) args=$main_args ;; *) args=$sqlite_args ;; esac
    markers=""; [[ $config == *E ]] && markers="--markers"
    for tree in "$@"; do
        cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
        taskset -c 2 ./build/compiler benchmark-preprocessor --only vectorized $markers $args > "$out/$config.$tree.$round.txt" 2>&1
    done
done
