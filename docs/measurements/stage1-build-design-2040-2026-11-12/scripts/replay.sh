#!/bin/bash
# Replay of main's last merges (first parents of c5f0efb2) on the checker's unit, a count and not a timing: the unit
# stopped before the optimizer at each merge, split by the prototype, and how many parts' bitcode differ from the merge
# before. Two recipes: g0 (no debug information; content-defined chunks, single callers with their callers) and g1 (line
# tables, DWARF 4; a file's chunks in its own parts, imports without debug information, single callers with their callers).
set -u
S=/tmp/claude-0/-home-user-buster/b7674301-5589-53a9-8832-8d0d8ba7e4ba/scratchpad
R=$S/dev/replay
cd $S/proto
compile() { clang $2 -march=native -I$S/proto/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-pc-linux-gnu"' -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O3 -fmacro-prefix-map=$S/proto/= -emit-llvm -Xclang -disable-llvm-passes -c src/buster/compiler/main_unit_checker.c -o $1; }
commits=$(git log --first-parent --format=%h -15 c5f0efb2 | tac)
previous=""
: > $R/replay.tsv
for commit in $commits; do
    git checkout -q $commit -- src
    compile $R/unit-g0.bc "" &
    compile $R/unit-g1.bc "-gdwarf-4 -gline-tables-only" &
    wait
    for recipe in g0 g1; do
        options="--cohere 150000"
        [ $recipe = g0 ] || options="--by-file --lean-imports --cohere 150000"
        rm -rf $R/$recipe-$commit; mkdir -p $R/$recipe-$commit
        $S/dev/presplit $R/unit-$recipe.bc 48 $R/$recipe-$commit --anchor 24 --import 100 $options > /dev/null 2>&1
        (cd $R/$recipe-$commit && sha256sum part*.bc > ../$recipe-$commit.sums && ls -l part*.bc | awk '{print $5, $9}' > ../$recipe-$commit.sizes)
        rm -rf $R/$recipe-$commit
        if [ -n "$previous" ]; then
            changed=$(diff $R/$recipe-$previous.sums $R/$recipe-$commit.sums | grep '^>' | awk '{print $3}')
            count=$(echo "$changed" | grep -c part)
            bytes=$(for p in $changed; do grep " $p\$" $R/$recipe-$commit.sizes | awk '{print $1}'; done | awk '{s+=$1} END {print s+0}')
            total=$(awk '{s+=$1} END {print s}' $R/$recipe-$commit.sizes)
            files=$(git diff --name-only $previous $commit -- src | wc -l)
            lines=$(git diff --shortstat $previous $commit -- src | sed 's/^ *//')
            printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$recipe" "$commit" "$files" "$count" "$bytes" "$total" "$lines" >> $R/replay.tsv
        fi
    done
    previous=$commit
done
git checkout -q c5f0efb2 -- src
echo done >> $R/replay.tsv
