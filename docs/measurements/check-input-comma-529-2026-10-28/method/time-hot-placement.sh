#!/usr/bin/env bash
# One individually locked cohort; the caller inspects the first SQLite result before any expansion.
set -euo pipefail
root=/home/david/buster-fast-bench/unclaimed-perf-20261028
stage=$root/issue-529-b8ee-clang2314
base=$root/integrated-e7-672-clang2314/compiler-native
kind=${1-}
round=${2-}
[[ $kind == sql || $kind == tiny || $kind == comma ]]
[[ $round == 1 || $round == 2 || $round == 3 ]]
cohort=$stage/layout-$kind-$round
test ! -e "$cohort"
mkdir "$cohort"
df -B1 /tmp > "$cohort/tmp-before.txt"
available=$(df -B1 --output=avail /tmp | tail -n 1)
test "$available" -gt 6000000000
for role in base head; do
    placements=$stage/hot-$role/placements
    if [[ ! -e $placements/compiler-only-SHA256SUMS ]]; then
        sha256sum -c "$placements/SHA256SUMS" > "$cohort/$role-all-identity.txt"
        sha256sum "$placements"/compiler-* > "$placements/compiler-only-SHA256SUMS"
    fi
    sha256sum -c "$placements/compiler-only-SHA256SUMS" > "$cohort/$role-identity-before.txt"
done
builds=()
for role in base head base-again; do
    source_role=base
    if [[ $role == head ]]; then source_role=head; fi
    for shift in 0 704 1408 2112 2752 3456; do
        builds+=(--build "$role" "$stage/hot-$source_role/placements/compiler-$shift")
    done
done
command=(--lanes 1 -c)
if [[ $kind == sql ]]; then
    corpus=$root/corpus
    command+=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
        -std=gnu17 --predefines "$corpus/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
        -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
else
    name=tiny
    if [[ $kind == comma ]]; then name=comma-1024; fi
    command+=(-std=gnu17 --target=x86_64-linux-gnu "$stage/method/$name.c")
fi
command+=(-o "$cohort/output.o")
"$base" time-runs --runs 3 --warmups 1 --copies 3 --directory /tmp "${builds[@]}" --list "${command[@]}"
for role in base head; do
    sha256sum -c "$stage/hot-$role/placements/compiler-only-SHA256SUMS" > "$cohort/$role-identity-after.txt"
done
sha256sum "$cohort/output.o" > "$cohort/output-SHA256.txt"
df -B1 /tmp > "$cohort/tmp-after.txt"
