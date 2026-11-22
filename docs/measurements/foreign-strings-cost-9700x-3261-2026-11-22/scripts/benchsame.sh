#!/bin/bash
# benchsame.sh: benchmark-foreign-strings (--keep, 3 runs, every variant) of main's and the fixed branch's Release
# executables on the shapes main has (unique, duplicate) at 4,096 and 131,072 literals, their merged outputs compared
# byte for byte; and the fixed branch's run of lengths and of every other shape (#3261; run under the 9700X's lock).
D=~/buster-fast-bench/3044-claude
rm -rf $D/out/bench && mkdir -p $D/out/bench/main $D/out/bench/fix
for shape in unique duplicate; do
    for t in main fix; do
        taskset -c 2 $D/$t/build/compiler benchmark-foreign-strings --keep --runs 3 --counts 4096,131072 --only $shape --directory $D/out/bench/$t | grep -v '^foreign-strings .* runs 3:'
    done
done
for t in main fix; do
    for f in $(cd $D/out/bench/main && ls */strings_output_* | sed 's|^[^/]*/||' | sort -u); do
        :
    done
done
for f in $(cd $D/out/bench/main/buster-foreign-strings-* 2>/dev/null && ls strings_output_* 2>/dev/null); do
    a=$(ls $D/out/bench/main/*/$f | head -1); b=$(ls $D/out/bench/fix/*/$f | head -1)
    echo "$f main-vs-fix $(cmp -s $a $b && echo identical || echo differs)"
done
for shape in lengths suffix repeats tie; do
    taskset -c 2 $D/fix/build/compiler benchmark-foreign-strings --runs 3 --counts 4096,131072 --only $shape | grep -v '^foreign-strings .* runs 3:'
done
