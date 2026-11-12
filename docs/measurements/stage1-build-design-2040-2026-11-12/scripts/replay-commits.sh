#!/bin/bash
# Replay of the last single commits to the sources (not merges) on the checker's unit, a count and not a timing: for each
# commit, the unit stopped before the optimizer at its parent and at the commit, split by the prototype without debug
# information (content-defined chunks, single callers with their callers), and how many of the 49 parts' bitcode differ.
set -u
S=/tmp/claude-0/-home-user-buster/b7674301-5589-53a9-8832-8d0d8ba7e4ba/scratchpad
R=$S/dev/replay
cd $S/proto
compile() { clang -march=native -I$S/proto/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-pc-linux-gnu"' -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O3 -fmacro-prefix-map=$S/proto/= -emit-llvm -Xclang -disable-llvm-passes -c src/buster/compiler/main_unit_checker.c -o $1; }
state()
{
    git checkout -q $1 -- src 2> /dev/null || return 1
    compile $R/c-$2.bc 2> $R/c-$2.err || return 1
    rm -rf $R/c-$2; mkdir -p $R/c-$2
    $S/dev/presplit $R/c-$2.bc 48 $R/c-$2 --anchor 24 --import 100 --cohere 150000 > /dev/null 2>&1 || return 1
    (cd $R/c-$2 && sha256sum part*.bc > ../c-$2.sums && ls -l part*.bc | awk '{print $5, $9}' > ../c-$2.sizes)
    rm -rf $R/c-$2 $R/c-$2.bc
}
: > $R/commits.tsv
for commit in $(git log --no-merges -24 --format=%h c5f0efb2 -- src); do
    if state $commit~1 before && state $commit after; then
        changed=$(diff $R/c-before.sums $R/c-after.sums | grep '^>' | awk '{print $3}')
        count=$(echo "$changed" | grep -c part)
        bytes=$(for p in $changed; do grep " $p\$" $R/c-after.sizes | awk '{print $1}'; done | awk '{s+=$1} END {print s+0}')
        total=$(awk '{s+=$1} END {print s}' $R/c-after.sizes)
        printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$commit" "$(git diff --name-only $commit~1 $commit -- src | wc -l)" "$count" "$bytes" "$total" "$(git diff --shortstat $commit~1 $commit -- src | sed 's/^ *//')" >> $R/commits.tsv
    else
        printf '%s\tfailed\n' "$commit" >> $R/commits.tsv
    fi
done
git checkout -q c5f0efb2 -- src
echo done >> $R/commits.tsv
