#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 combined corpus and counts' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f parameters-v16-tests.done ]; do
    if [ -s parameters-v16-tests.status ] && awk '$2 != 0 { bad = 1 } END { exit !bad }' parameters-v16-tests.status; then
        printf 'Native qualification failed; no counts were run.\n' >&2
        exit 1
    fi
    sleep 2
done
"$HOME/buster-fast-bench/exclusive.sh" sha256sum --check parameters-v16-binaries.sha256
test -x results/parameters-v16/st-t1
test -x results/parameters-v16/lua-t1
printf '%s\n' dfd2183a3bbe96f8a99d39b1c36036aeb500ac08 > results/parameters-v16/source.txt
sha256sum parameters-v16/build/compiler results/parameters-v16/{st-t1,lua-t1} > parameters-v16-binaries.sha256
export VALGRIND_LIB="$S/valgrind/lib/valgrind"
export PATH="$S/valgrind/bin:$PATH"
directory="$S/results/parameters-v16"
mkdir -p "$directory/cg"
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh st "$directory/st-t1" "$directory/verify.out" --verify
for program in st calls tables strings arithmetic closures; do
    if [ "$program" = st ]; then args=(st "$directory/st-t1"); else args=(lua "$directory/lua-t1"); fi
    extra=()
    [ "$program" = st ] || extra=("$program.lua")
    VG=1 VGOPTS=--dump-instr=yes "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh "${args[@]}" "$directory/cg/$program.out" "${extra[@]}"
    printf '%s done\n' "$program" >> parameters-v16-counts.status
    if [ "$program" != st ]; then cmp "$directory/cg/$program.out" "$S/results/base/cg/$program.out"; fi
done
touch parameters-v16-counts.done
