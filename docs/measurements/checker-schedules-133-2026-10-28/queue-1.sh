#!/bin/bash
# #133's 9700X runs, each under the lock on its own: both builds, the source benchmark's three paths, and main against head.
echo $$ > ~/buster-fast-bench/claude-133/queue.pid
cd ~/buster-fast-bench/claude-133
export EXCLUSIVE_OWNER=claude-133 EXCLUSIVE_TITLE="#133: constraint catalogue, comparison builtins, K&R, schedules" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/133"
X=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
sqlite=$corpus/sqlite
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
(cd main && BUSTER_DEBUG_INFO=0 $X ./build.sh) > build-main.log 2>&1
(cd head && BUSTER_DEBUG_INFO=0 $X ./build.sh) > build-head.log 2>&1
for i in 1 2 3; do
    $X taskset -c 2 head/build/compiler benchmark-checker-source "${source[@]}" > bench-head-$i.log 2>&1
    sleep 15
    $X taskset -c 2 main/build/compiler benchmark-checker-source "${source[@]}" > bench-main-$i.log 2>&1
    sleep 15
done
for p in scalar vector postorder; do
    $X taskset -c 2 head/build/compiler benchmark-checker-source --only $p "${source[@]}" > only-$p.log 2>&1
    sleep 10
done
for p in vector postorder; do
    $X taskset -c 2 head/build/compiler benchmark-checker-source --only $p --after-scalar 100 "${source[@]}" > only-$p-after.log 2>&1
    sleep 10
done
$X taskset -c 2 head/build/compiler time-runs --runs 21 --build main main/build/compiler --build head head/build/compiler --list -c "${options[@]}" -o out.o --list -fsyntax-only "${options[@]}" > time-runs.log 2>&1
echo done > queue.done
