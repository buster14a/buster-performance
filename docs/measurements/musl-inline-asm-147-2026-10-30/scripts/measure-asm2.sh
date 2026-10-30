#!/bin/bash
# #147's musl inline assembly, after the AT&T extension rows' fix: main 7f857786 against c169c6ee. The frozen
# sqlite3.c's -c objects compared and three perf stat runs of each tree's -c for user instructions; then
# benchmark-assembler's four workloads, each process under the lock alone on CPU 2, five rounds alternating the trees.
cd ~/buster-fast-bench/solve-147-claude
echo $$ > measure-asm2.pid
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="solve #137 #147 #148 (#147: musl inline asm A/B, AT&T fix)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
M=main-7f857786
H=asm-c169c6ee
./build-tree.sh $H; echo "build $H: $?"
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for t in $M $H; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler -c "${O[@]}" -o /tmp/s147b-$t.o
    echo "$t -c: status $?"
done
cmp /tmp/s147b-$M.o /tmp/s147b-$H.o && echo "objects: identical"
for t in $M $H; do
    for r in 1 2 3; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o stat2-$t-c-$r.csv ./$t/build/compiler -c "${O[@]}" -o /tmp/s147b-stat-$t.o
        echo "$t -c instructions (status $?): $(grep instructions stat2-$t-c-$r.csv | cut -d, -f1)"
    done
done
mkdir -p asmbench2
for r in 1 2 3 4 5; do
    if [ $((r % 2)) -eq 1 ]; then order="$M $H"; else order="$H $M"; fi
    for t in $order; do
        for w in mixed registers simd att; do
            args=()
            [ "$w" = mixed ] || args=(--workload "$w")
            ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler benchmark-assembler "${args[@]}" > asmbench2/$t-$w-$r.txt 2>&1
            echo "benchmark-assembler $t $w round $r: status $?"
        done
    done
done
~/buster-fast-bench/exclusive.sh bash -c "sha256sum $M/build/compiler $H/build/compiler; cat $M/COMMIT $H/COMMIT" > hostinfo-asm2.out 2>&1
echo done
