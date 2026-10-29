#!/bin/bash
# #787's per-function promotion times on the 9700X: benchmark-ir-source --functions on the frozen sqlite3.c and on
# musl's units, with the branch's tree (claude/ssa-vector-path-787 at its first commit), pinned to CPU 2, each run its
# own hold of the shared lock.
echo $$ > ~/buster-fast-bench/claude-787/queue-b.pid
until grep -q done ~/buster-fast-bench/claude-787/out/progress 2>/dev/null; do sleep 10; done
cd ~/buster-fast-bench/claude-787
out=~/buster-fast-bench/claude-787/out
lock()
{
    EXCLUSIVE_OWNER=claude-787 EXCLUSIVE_TITLE="SSA promotion's vector path (#787)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/787 ~/buster-fast-bench/exclusive.sh "$@"
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
lock bash -c "cd tree && BUSTER_DEBUG_INFO=0 ./build.sh" > "$out/build-tree.log" 2>&1
echo "build tree: $?" >> "$out/progress-b"
source_options="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
lock bash -c "cd tree && taskset -c 2 ./build/compiler benchmark-ir-source --functions $source_options" > "$out/functions-sqlite.log" 2>&1
echo "functions sqlite: $?" >> "$out/progress-b"
lock bash -c "cd tree && taskset -c 2 ./build/compiler benchmark-ir-source --functions --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include $musl/src/*/*.c $musl/src/*/x86_64/*.c" > "$out/functions-musl.log" 2>&1
echo "functions musl: $?" >> "$out/progress-b"
echo done >> "$out/progress-b"
