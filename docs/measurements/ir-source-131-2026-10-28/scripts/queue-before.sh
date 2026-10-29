#!/bin/bash
# The rest of q131b.sh: its checker unit holds printed no time (the host has no bc), so they are run again here with
# date +%s%N and shell arithmetic, then the IR's benchmarks, as q131b.sh would have run them.
echo $$ > ~/buster-fast-bench/claude-131/queue.pid
cd ~/buster-fast-bench/claude-131
out=~/buster-fast-bench/claude-131/out
lock()
{
    EXCLUSIVE_OWNER=claude-131 EXCLUSIVE_TITLE="solve #131 (IR source corpus)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/131 ~/buster-fast-bench/exclusive.sh "$@"
}
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
order()
{
    if [ $(( $1 % 2 )) = 1 ]; then echo main head; else echo head main; fi
}
flags="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -O3"
for round in 1 2; do
    script=""
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-131/$tree && s=\$(date +%s%N) && taskset -c 2 clang -c src/buster/compiler/main_unit_checker.c -o /tmp/claude-131-checker-$tree.o $flags && e=\$(date +%s%N) && echo \"checker unit $tree $round: \$(( (e - s) / 1000000 )) ms\"; rm -f /tmp/claude-131-checker-$tree.o;"
    done
    lock bash -c "$script" >> "$out/pair-checker-unit-c.log" 2>&1
    echo "pair checker unit $round: $?" >> "$out/progress-c"
done
script=""
for round in 1 2 3; do
    for b in benchmark-ir benchmark-ir-lowering; do
        for tree in $(order $round); do
            script="$script cd ~/buster-fast-bench/claude-131/$tree && taskset -c 2 ./build/compiler $b > $out/pair-$b-$tree-$round.log 2>&1; echo $b $tree $round \$?;"
        done
    done
done
for b in benchmark-ir-optimize benchmark-ir-optimize-passes; do
    for tree in head main; do
        script="$script cd ~/buster-fast-bench/claude-131/$tree && taskset -c 2 ./build/compiler $b > $out/pair-$b-$tree-1.log 2>&1; echo $b $tree 1 \$?;"
    done
done
lock bash -c "$script" > "$out/pair-benchmarks.log" 2>&1
echo "pair benchmarks: $?" >> "$out/progress-c"
echo done >> "$out/progress-c"
