#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 instruction counts' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1219
export VALGRIND_LIB="$S/valgrind/lib/valgrind"
export PATH="$S/valgrind/bin:$PATH"
while [ ! -f corpora.done ]; do sleep 2; done
for build in base head clang; do
    directory="$S/results/$build"
    mkdir -p "$directory/cg"
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh st "$directory/st-t1" "$directory/verify.out" --verify
    grep 'Verification Hash' "$directory/verify.out" >> verify-hashes.txt
    for program in st calls tables strings arithmetic closures; do
        if [ "$program" = st ]; then args=(st "$directory/st-t1"); else args=(lua "$directory/lua-t1"); fi
        extra=()
        [ "$program" = st ] || extra=("$program.lua")
        VG=1 VGOPTS=--dump-instr=yes "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh "${args[@]}" "$directory/cg/$program.out" "${extra[@]}"
        printf '%s %s done\n' "$build" "$program" >> counts.status
        if [ "$build" != base ] && [ "$program" != st ]; then cmp "$directory/cg/$program.out" "$S/results/base/cg/$program.out"; fi
    done
done
test "$(sort -u verify-hashes.txt | wc -l)" -eq 1
touch counts.done
