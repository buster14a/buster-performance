#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 combined corpus and counts' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f latest-base-programs.done ]; do
    if [ -s latest-base-tests.status ] && awk '$2 != 0 { bad = 1 } END { exit !bad }' latest-base-tests.status; then
        printf 'Native qualification failed; no counts were run.\n' >&2
        exit 1
    fi
    sleep 2
done
"$HOME/buster-fast-bench/exclusive.sh" sha256sum --check latest-base-binaries.sha256
test -x results/latest-base/st-t1
test -x results/latest-base/lua-t1
printf '%s\n' 1bfc57eedf9c2fc3deb5a71a22b7c2a4f01ee29f > results/latest-base/source.txt
sha256sum latest-base/build/compiler results/latest-base/{st-t1,lua-t1} > latest-base-binaries.sha256
export VALGRIND_LIB="$S/valgrind/lib/valgrind"
export PATH="$S/valgrind/bin:$PATH"
directory="$S/results/latest-base"
mkdir -p "$directory/cg"
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh st "$directory/st-t1" "$directory/verify.out" --verify
for program in st calls tables strings arithmetic closures; do
    if [ "$program" = st ]; then args=(st "$directory/st-t1"); else args=(lua "$directory/lua-t1"); fi
    extra=()
    [ "$program" = st ] || extra=("$program.lua")
    VG=1 VGOPTS=--dump-instr=yes "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/run.sh "${args[@]}" "$directory/cg/$program.out" "${extra[@]}"
    printf '%s done\n' "$program" >> latest-base-counts.status
    if [ "$program" != st ]; then cmp "$directory/cg/$program.out" "$S/results/base/cg/$program.out"; fi
done
touch latest-base-counts.done
