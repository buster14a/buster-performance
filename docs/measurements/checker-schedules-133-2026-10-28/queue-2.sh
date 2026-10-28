#!/bin/bash
# #133's second 9700X round, each run under the lock on its own: the build of commit fe35a8b5 (head2: the postorder
# batches the default, level order the benchmark's third path), the source benchmark's three paths against main's, and
# main, head (0f26899e, round 1's) and head2 as whole compiles.
echo $$ > ~/buster-fast-bench/claude-133/queue2.pid
cd ~/buster-fast-bench/claude-133
export EXCLUSIVE_OWNER=claude-133 EXCLUSIVE_TITLE="#133: constraint catalogue, comparison builtins, K&R, schedules" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/133"
X=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
sqlite=$corpus/sqlite
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
(cd head2 && BUSTER_DEBUG_INFO=0 $X ./build.sh) > build-head2.log 2>&1
for i in 1 2 3; do
    $X taskset -c 2 head2/build/compiler benchmark-checker-source "${source[@]}" > bench2-head2-$i.log 2>&1
    sleep 15
    $X taskset -c 2 main/build/compiler benchmark-checker-source "${source[@]}" > bench2-main-$i.log 2>&1
    sleep 15
done
for p in scalar vector levels; do
    $X taskset -c 2 head2/build/compiler benchmark-checker-source --only $p "${source[@]}" > only2-$p.log 2>&1
    sleep 10
done
for p in vector levels; do
    $X taskset -c 2 head2/build/compiler benchmark-checker-source --only $p --after-scalar 100 "${source[@]}" > only2-$p-after.log 2>&1
    sleep 10
done
$X taskset -c 2 head2/build/compiler time-runs --runs 21 --build main main/build/compiler --build head head/build/compiler --build head2 head2/build/compiler --list -c "${options[@]}" -o out.o --list -fsyntax-only "${options[@]}" > time-runs2.log 2>&1
echo done > queue2.done
