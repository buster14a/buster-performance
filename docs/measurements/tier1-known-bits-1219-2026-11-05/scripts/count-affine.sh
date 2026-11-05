#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 combined corpus and counts' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f affine-recheck.done ]; do sleep 2; done
test "$(cat affine-recheck.done)" = 0
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/progs.sh "$PWD/affine/build/compiler" "$PWD/results/affine"
test -x results/affine/st-t1
test -x results/affine/lua-t1
printf '%s\n' 08545d5c765912a08967dd66e19298c28f1eedb8 > results/affine/source.txt
sha256sum affine/build/compiler results/affine/{st-t1,lua-t1} > affine-binaries.sha256
export VALGRIND_LIB="$S/valgrind/lib/valgrind"
export PATH="$S/valgrind/bin:$PATH"
directory="$S/results/affine"
mkdir -p "$directory/cg"
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh st "$directory/st-t1" "$directory/verify.out" --verify
for program in st calls tables strings arithmetic closures; do
    if [ "$program" = st ]; then args=(st "$directory/st-t1"); else args=(lua "$directory/lua-t1"); fi
    extra=()
    [ "$program" = st ] || extra=("$program.lua")
    VG=1 VGOPTS=--dump-instr=yes "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh "${args[@]}" "$directory/cg/$program.out" "${extra[@]}"
    printf '%s done\n' "$program" >> affine-counts.status
    if [ "$program" != st ]; then cmp "$directory/cg/$program.out" "$S/results/base/cg/$program.out"; fi
done
touch affine-counts.done
