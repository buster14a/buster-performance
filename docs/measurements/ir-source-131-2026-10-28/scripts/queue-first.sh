#!/bin/bash
# #131's qualification on the 9700X: each step its own hold of the shared lock.
echo $$ > ~/buster-fast-bench/claude-131/queue.pid
cd ~/buster-fast-bench/claude-131
out=~/buster-fast-bench/claude-131/out
mkdir -p "$out"
lock()
{
    EXCLUSIVE_OWNER=claude-131 EXCLUSIVE_TITLE="solve #131 (IR source corpus)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/131 ~/buster-fast-bench/exclusive.sh "$@"
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
source_options="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
ct_files="$(sed -n "s|^\([0-9][0-9]*\)$|$HOME/buster-fast-bench/claude-131/ct/c-testsuite/tests/single-exec/\1.c|p" head/tests/c-testsuite/subset.txt)"
for tree in head main; do
    lock bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh" > "$out/build-$tree.log" 2>&1
    echo "build $tree: $?" >> "$out/progress"
done
lock bash -c "cd head && for t in test-ir test-ir-parse test-ssa-ir test-ir-interpreter test-ir-optimize test-ir-inline test-tier1-select test-tier1-pipeline test-call-graph; do ./build/compiler \$t > $out/head-\$t.log 2>&1; echo \"\$t: \$?\"; done" > "$out/tests-1.log" 2>&1
echo "tests-1: $?" >> "$out/progress"
lock bash -c "cd head && ./build/compiler test-ir-lowering" > "$out/head-test-ir-lowering.log" 2>&1
echo "test-ir-lowering: $?" >> "$out/progress"
lock bash -c "cd head && ./build/compiler test-ir-source $ct_files > $out/head-ir-source-ct.log 2>&1; echo ct \$?; ./build/compiler test-ir-source $source_options > $out/head-ir-source-sqlite.log 2>&1; echo sqlite \$?; ./build.sh check-call-graph > $out/head-call-graph.log 2>&1; echo call-graph \$?" > "$out/tests-2.log" 2>&1
echo "tests-2: $?" >> "$out/progress"
lock bash -c "cd head && taskset -c 2 ./build/compiler benchmark-ir-source $source_options" > "$out/benchmark-ir-source.log" 2>&1
echo "benchmark-ir-source: $?" >> "$out/progress"
lock bash -c "cd head && taskset -c 2 ./build/compiler benchmark-ir-source --only lower --after-scalar 200 $source_options" > "$out/benchmark-ir-source-after.log" 2>&1
echo "benchmark-ir-source after-scalar: $?" >> "$out/progress"
for round in 1 2 3; do
    for tree in main head; do
        for b in benchmark-ir benchmark-ir-lowering benchmark-ir-optimize benchmark-ir-optimize-passes; do
            lock bash -c "cd $tree && taskset -c 2 ./build/compiler $b" > "$out/$b-$tree-$round.log" 2>&1
            echo "$b $tree $round: $?" >> "$out/progress"
        done
    done
done
sqlite_options="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$corpus/sqlite $corpus/sqlite/sqlite3.c"
for round in 1 2 3; do
    for tree in main head; do
        lock bash -c "cd $tree && taskset -c 2 perf stat -r 11 -e cycles:u,instructions:u -x, -o $out/compile-$tree-$round.csv ./build/compiler $sqlite_options -o $out/sqlite3-$tree.o" > "$out/compile-$tree-$round.log" 2>&1
        echo "compile $tree $round: $?" >> "$out/progress"
    done
done
cmp "$out/sqlite3-main.o" "$out/sqlite3-head.o" > "$out/object-cmp.log" 2>&1
echo "object cmp: $?" >> "$out/progress"
flags="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -O3"
for round in 1 2; do
    for tree in main head; do
        lock bash -c "cd $tree && s=\$(date +%s.%N); taskset -c 2 clang -c src/buster/compiler/main_unit_checker.c -o /tmp/claude-131-checker-$tree.o $flags; e=\$(date +%s.%N); echo \"checker unit $tree: \$(echo \"\$e - \$s\" | bc) s\"; rm -f /tmp/claude-131-checker-$tree.o" >> "$out/checker-unit.log" 2>&1
        echo "checker unit $tree $round: $?" >> "$out/progress"
    done
done
echo done >> "$out/progress"
