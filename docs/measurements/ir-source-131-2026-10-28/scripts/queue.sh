#!/bin/bash
# #131's final qualification on the 9700X, of head a47f090d against main 9bb5060e (whose build out/ already used): a
# hold each for head's build, its tests, benchmark-ir-source and its after-scalar run; then main/head pairs, the order
# alternating by round: the -c compiles (about 15 s), each checker unit pair (about 50 s) and the IR's benchmarks
# (about 25 s).
echo $$ > ~/buster-fast-bench/claude-131/queue.pid
cd ~/buster-fast-bench/claude-131
out=~/buster-fast-bench/claude-131/out2
lock()
{
    EXCLUSIVE_OWNER=claude-131 EXCLUSIVE_TITLE="solve #131 (IR source corpus)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/131 ~/buster-fast-bench/exclusive.sh "$@"
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
order()
{
    if [ $(( $1 % 2 )) = 1 ]; then echo main head; else echo head main; fi
}
source_options="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
musl_options="--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include $(echo $musl/src/*/*.c $musl/src/*/x86_64/*.c)"
ct_files="$(sed -n "s|^\([0-9][0-9]*\)$|$HOME/buster-fast-bench/claude-131/ct/c-testsuite/tests/single-exec/\1.c|p" head/tests/c-testsuite/subset.txt | tr '\n' ' ')"
lock bash -c "cd head && BUSTER_DEBUG_INFO=0 ./build.sh" > "$out/build-head.log" 2>&1
echo "build head: $?" >> "$out/progress"
lock bash -c "cd head && for t in test-ir test-ir-parse test-ssa-ir test-ir-interpreter test-ir-optimize test-ir-inline test-ir-gvn test-ir-licm test-ir-sroa test-tier1-select test-tier1-pipeline test-call-graph test-ir-lowering; do ./build/compiler \$t > $out/head-\$t.log 2>&1; echo \"\$t: \$?\"; done; ./build/compiler test-ir-source $ct_files > $out/head-ir-source-ct.log 2>&1; echo \"ir-source ct: \$?\"; ./build/compiler test-ir-source $source_options > $out/head-ir-source-sqlite.log 2>&1; echo \"ir-source sqlite: \$?\"; ./build/compiler test-ir-source $musl_options > $out/head-ir-source-musl.log 2>&1; echo \"ir-source musl: \$?\"; ./build.sh check-call-graph > $out/head-call-graph.log 2>&1; echo \"call graph: \$?\"" > "$out/tests.log" 2>&1
echo "tests: $?" >> "$out/progress"
lock bash -c "cd head && taskset -c 2 ./build/compiler benchmark-ir-source $source_options" > "$out/benchmark-ir-source.log" 2>&1
echo "benchmark-ir-source: $?" >> "$out/progress"
lock bash -c "cd head && taskset -c 2 ./build/compiler benchmark-ir-source --only lower --after-scalar 200 $source_options" > "$out/benchmark-ir-source-after.log" 2>&1
echo "benchmark-ir-source after-scalar: $?" >> "$out/progress"
sqlite_options="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$corpus/sqlite $corpus/sqlite/sqlite3.c"
script=""
for round in 1 2 3; do
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-131/$tree && taskset -c 2 perf stat -r 11 -e cycles:u,instructions:u,task-clock -x, -o $out/pair-compile-$tree-$round.csv ./build/compiler $sqlite_options -o $out/pair-sqlite3-$tree.o; echo compile $tree $round \$?;"
    done
done
lock bash -c "$script" > "$out/pair-compile.log" 2>&1
echo "pair compile: $?" >> "$out/progress"
cmp "$out/pair-sqlite3-main.o" "$out/pair-sqlite3-head.o" > "$out/pair-object-cmp.log" 2>&1
echo "pair object cmp: $?" >> "$out/progress"
flags="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -O3"
for round in 1 2; do
    script=""
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-131/$tree && s=\$(date +%s%N) && taskset -c 2 clang -c src/buster/compiler/main_unit_checker.c -o /tmp/claude-131-checker-$tree.o $flags && e=\$(date +%s%N) && echo \"checker unit $tree $round: \$(( (e - s) / 1000000 )) ms\"; rm -f /tmp/claude-131-checker-$tree.o;"
    done
    lock bash -c "$script" >> "$out/pair-checker-unit.log" 2>&1
    echo "pair checker unit $round: $?" >> "$out/progress"
done
script=""
for round in 1 2 3; do
    for b in benchmark-ir benchmark-ir-lowering; do
        for tree in $(order $round); do
            script="$script cd ~/buster-fast-bench/claude-131/$tree && taskset -c 2 ./build/compiler $b > $out/pair-$b-$tree-$round.log 2>&1; echo $b $tree $round \$?;"
        done
    done
done
for round in 1 2; do
    for b in benchmark-ir-optimize benchmark-ir-optimize-passes; do
        for tree in $(order $round); do
            script="$script cd ~/buster-fast-bench/claude-131/$tree && taskset -c 2 ./build/compiler $b > $out/pair-$b-$tree-$round.log 2>&1; echo $b $tree $round \$?;"
        done
    done
done
lock bash -c "$script" > "$out/pair-benchmarks.log" 2>&1
echo "pair benchmarks: $?" >> "$out/progress"
echo done >> "$out/progress"
