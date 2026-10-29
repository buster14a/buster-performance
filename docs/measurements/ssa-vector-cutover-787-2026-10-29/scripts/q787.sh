#!/bin/bash
# #787's profile on the 9700X: where ssa_ir_promote's vector path spends its time against its scalar twin, on the frozen
# sqlite3.c's functions, with main d11a91d2's build (claude-784/main): benchmark-ir-source --only promote and
# --only promote-scalar, back to back and after 200 ms of scalar work, then each under perf record (cycles:u) with
# perf report by symbol, and perf stat's front-end and throttle counters; each run its own hold of the shared lock.
echo $$ > ~/buster-fast-bench/claude-787/queue.pid
mkdir -p ~/buster-fast-bench/claude-787/out
out=~/buster-fast-bench/claude-787/out
lock()
{
    EXCLUSIVE_OWNER=claude-787 EXCLUSIVE_TITLE="SSA promotion's vector path (#787)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/787 ~/buster-fast-bench/exclusive.sh "$@"
}
until grep -q done ~/buster-fast-bench/claude-784/out/progress 2>/dev/null; do sleep 10; done
tree=~/buster-fast-bench/claude-784/main
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
source_options="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for v in promote promote-scalar; do
    lock bash -c "cd $tree && taskset -c 2 ./build/compiler benchmark-ir-source --only $v $source_options" > "$out/only-$v.log" 2>&1
    echo "only $v: $?" >> "$out/progress"
done
lock bash -c "cd $tree && taskset -c 2 ./build/compiler benchmark-ir-source --only promote --after-scalar 200 $source_options" > "$out/after-promote.log" 2>&1
echo "after promote: $?" >> "$out/progress"
for v in promote promote-scalar; do
    lock bash -c "cd $tree && taskset -c 2 perf record -e cycles:u -c 200003 -o $out/perf-$v.data ./build/compiler benchmark-ir-source --only $v $source_options > $out/perf-$v.log 2>&1 && perf report -i $out/perf-$v.data --no-children --sort symbol --stdio 2>/dev/null | head -60 > $out/report-$v.txt"
    echo "perf $v: $?" >> "$out/progress"
    lock bash -c "cd $tree && taskset -c 2 perf stat -x, -e instructions:u,cycles:u,r1000001a0,r1000008a0 -o $out/stat-$v.csv ./build/compiler benchmark-ir-source --only $v $source_options > $out/stat-$v.log 2>&1"
    echo "stat $v: $?" >> "$out/progress"
done
echo done >> "$out/progress"
