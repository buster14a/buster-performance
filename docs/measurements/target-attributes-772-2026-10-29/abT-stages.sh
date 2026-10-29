#!/bin/bash
# Which stage holds #772's head's (6ab01f9) fewer user instructions than its base's (7dae48f) on the frozen sqlite3.c:
# perf stat's exact counts of -E, of the parser's driver and of -fsyntax-only, by base, by an A/A copy of it and by
# head, each run under its own hold of the 9700X's lock, pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): a function's target attribute, against #771" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/772
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abT
export TMPDIR=$here/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
options=(--clang-features --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
source="$corpus/sqlite/sqlite3.c"
cd "$here"
: > stages.log
for tree in base aa head; do
    for stage in preprocess parse check; do
        case $stage in
            preprocess) command=($tree/build/compiler -E -o /dev/null "${options[@]}" "$source");;
            parse) command=($tree/build/compiler parse -fsyntax-only "${options[@]}" "$source");;
            check) command=($tree/build/compiler -fsyntax-only "${options[@]}" "$source");;
        esac
        echo "== $tree $stage" >> stages.log
        $lock perf stat -x, -e instructions:u -r 5 taskset -c 2 "${command[@]}" 2>> stages.log > /dev/null
    done
done
echo "staged"
