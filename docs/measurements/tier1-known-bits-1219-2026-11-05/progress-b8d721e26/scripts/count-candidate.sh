#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 combined corpus and counts' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f fixed-v8-tests.done ]; do
    if [ -s fixed-v8-tests.status ] && awk '$2 != 0 { bad = 1 } END { exit !bad }' fixed-v8-tests.status; then
        printf 'Native qualification failed; no counts were run.\n' >&2
        exit 1
    fi
    sleep 2
done
"$HOME/buster-fast-bench/exclusive.sh" sha256sum --check fixed-v8-binaries.sha256
test -x results/fixed-v8/st-t1
test -x results/fixed-v8/lua-t1
printf '%s\n' b8d721e26f21f2b03229e071622ad4ed374a6e93 > results/fixed-v8/source.txt
sha256sum fixed-v8/build/compiler results/fixed-v8/{st-t1,lua-t1} > fixed-v8-binaries.sha256
export VALGRIND_LIB="$S/valgrind/lib/valgrind"
export PATH="$S/valgrind/bin:$PATH"
directory="$S/results/fixed-v8"
mkdir -p "$directory/cg"
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh st "$directory/st-t1" "$directory/verify.out" --verify
for program in st calls tables strings arithmetic closures; do
    if [ "$program" = st ]; then args=(st "$directory/st-t1"); else args=(lua "$directory/lua-t1"); fi
    extra=()
    [ "$program" = st ] || extra=("$program.lua")
    VG=1 VGOPTS=--dump-instr=yes "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh "${args[@]}" "$directory/cg/$program.out" "${extra[@]}"
    printf '%s done\n' "$program" >> fixed-v8-counts.status
    if [ "$program" != st ]; then cmp "$directory/cg/$program.out" "$S/results/base/cg/$program.out"; fi
done
touch fixed-v8-counts.done
