#!/bin/bash
# #126's builtins (abb3: main d1f9dad3 against b8cfc237) and initializers (abb4: #480's 77bd4aa8 against a01929be): the
# typed checking of the frozen sqlite3.c's bodies in the process, the whole -fsyntax-only driver, and its user
# instructions and cycles, each build and run under its own hold of the shared lock, pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: builtins and initializers A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
for ab in abb3 abb4; do
    cd ~/buster-fast-bench/solve-126-claude/$ab
    (cd head && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_head.log 2>&1) || { echo "$ab build head failed"; continue; }
    echo "$ab built head"
    for tree in base head; do
        $lock taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" > drive_$tree.log 2>&1
        echo "$ab drive $tree status $?"
    done
    ./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- benchmark-checker-source "${source[@]}" > ab_source.log 2>&1
    echo "$ab ab source status $?"
    ./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 21 --list -fsyntax-only "${driver[@]}" > ab_driver.log 2>&1
    echo "$ab ab driver status $?"
    for round in 1 2 3; do
        for tree in base head; do
            echo "== round $round tree $tree" >> perf.log
            $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:" >> perf.log
        done
    done
    echo "$ab perf done"
done
echo done
