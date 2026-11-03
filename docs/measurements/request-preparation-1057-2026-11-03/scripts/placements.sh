#!/bin/bash
# The record's placement campaign (#1057, after #1209's review): the paired runs of logs/lua.log, logs/tiny.log and
# logs/backend-source.log put the merge slower in most pairs while it runs fewer instructions, which one executable per
# tree can't tell from code placement (#509, docs/profiling.md). So, as docs/profiling.md's "Builds over their code's
# placements and copies" does: each tree's checker unit at six placements over a page, multiples of its .text's
# alignment, 64 bytes (a first attempt with shifts of 688 bytes failed to build: logs/*-attempt1*), by ./build.sh
# shifts, each tree's own, each build in a hold of the lock; then three rounds of ab (which takes the lock for each
# time-runs process) of
# time-runs over main's, the merge's and main's again placements (main-again: the comparison's own floor), three fresh
# copies each, on CPU 2: Lua's 33 units by --lanes 1 -c and --lanes 1 -fsyntax-only, the tiny file's -c and
# sqlite3.c's -c.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1057-claude/record; L=$R/logs
export EXCLUSIVE_OWNER=claude-1057 EXCLUSIVE_TITLE="#1057 preparation cost record" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1057
shifts="0 640 1344 2048 2752 3456"
for t in 754475d4 4670b2eb; do
    (cd $R/trees/tree-$t && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh shifts $R/shifts/$t main_unit_checker.c $shifts > $L/shifts-build-$t.log 2>&1
     echo "shifts $t build status $?" >> $L/receipts.txt)
    (cd $R/shifts/$t && sha256sum compiler-*) >> $L/receipts.txt
done
builds=()
for b in main:754475d4 head:4670b2eb main-again:754475d4; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$R/shifts/${b#*:}/compiler-$s"); done
done
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
files=$(ls $R/inputs/lua/*.c)
sqlite=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
main=$R/trees/tree-754475d4/build/compiler
mkdir -p $R/out/placements && cd $R/out/placements
$main ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $main -- time-runs --runs 3 --copies 3 "${builds[@]}" \
    --list --lanes 1 -c "${lua[@]}" $files --list --lanes 1 -fsyntax-only "${lua[@]}" $files \
    --list -c -o $R/out/placements/tiny.o $R/inputs/tiny.c --list -c -o $R/out/placements/sqlite.o "${sqlite[@]}" > $L/placements.log 2>&1
echo "placements ab status $?" >> $L/receipts.txt
