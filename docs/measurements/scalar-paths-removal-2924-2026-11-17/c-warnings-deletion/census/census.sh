#!/bin/bash
# #2924 C12c-2: which of the warnings area's scalar arms the gate's lists reach. The tree is the warnings branch's base
# (#3047's head) with census.py's counters; -c --lanes 1 of sqlite3.c, Lua's units and musl's units, by default and
# with --scalar, each under the lock, BUSTER_WCENSUS=FILE appending every helper's arm counts there at exit (BUSTER_EXIT_HELPER=0: the helper closes the descriptors first).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the warnings' census, C12c-2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
: > logs/status.txt
rm -f logs/*.census
(cd tree && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp tree/build/compiler compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/../c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
out=/dev/shm/claude-2924-c12w-census
for mode in default scalar; do
    case $mode in default) opt=();; scalar) opt=(--scalar);; esac
    rm -rf "$out"; mkdir -p "$out/sqlite" "$out/lua" "$out/musl"
    (cd "$out/sqlite" && BUSTER_EXIT_HELPER=0 BUSTER_WCENSUS="$D/logs/$mode-sqlite.census" $L timeout -k 5 1500 taskset -c 2 "$D/compiler" -c --lanes 1 "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$D/logs/$mode-sqlite.err"); echo "$mode sqlite: $?" >> logs/status.txt
    (cd "$out/lua" && BUSTER_EXIT_HELPER=0 BUSTER_WCENSUS="$D/logs/$mode-lua.census" $L timeout -k 5 1500 taskset -c 2 "$D/compiler" -c --lanes 1 "${opt[@]}" "$lua"/*.c > /dev/null 2> "$D/logs/$mode-lua.err"); echo "$mode lua: $?" >> logs/status.txt
    (cd "$out/musl" && BUSTER_EXIT_HELPER=0 BUSTER_WCENSUS="$D/logs/$mode-musl.census" $L timeout -k 5 1500 taskset -c 2 "$D/compiler" -c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$D/logs/$mode-musl.err"); echo "$mode musl: $?" >> logs/status.txt
done
rm -rf "$out"
echo done >> logs/status.txt
