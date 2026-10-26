#!/bin/bash
# #480: what main.c's constructs (the loop and FP_CONTRACT pragmas, no_builtin, inferred aggregate sizes) cost checking,
# main 22e32590 (base) against #480's head 77bd4aa8 (head), on the frozen sqlite3.c: the typed checking of its bodies in the
# process, and the whole -fsyntax-only driver.
set -u
cd ~/buster-fast-bench/solve-126-claude/ab480
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: #480 A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/480
lock=~/buster-fast-bench/exclusive.sh
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree"
done
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
for tree in base head; do
    $lock taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" > drive_$tree.log 2>&1
    echo "drive $tree status $?"
done
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- benchmark-checker-source "${source[@]}" > ab_source.log 2>&1
echo "ab source status $?"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 21 --list -fsyntax-only "${driver[@]}" > ab_driver.log 2>&1
echo "ab driver status $?"
echo done
