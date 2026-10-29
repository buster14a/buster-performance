#!/bin/bash
# #787's qualification on the 9700X: head bfde0695 against its base, main 74af9937, each step its own hold of the shared
# lock: both builds, then main/head pairs alternating by round (three rounds) of benchmark-ir-source on the frozen
# sqlite3.c: promote back to back, promote after 200 ms of scalar work, and promote-scalar, which neither changes.
echo $$ > ~/buster-fast-bench/claude-787/queue-c.pid
cd ~/buster-fast-bench/claude-787
out=~/buster-fast-bench/claude-787/out-c
mkdir -p "$out"
lock()
{
    EXCLUSIVE_OWNER=claude-787 EXCLUSIVE_TITLE="SSA promotion's vector path (#787)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/787 ~/buster-fast-bench/exclusive.sh "$@"
}
order()
{
    if [ $(( $1 % 2 )) = 1 ]; then echo main head; else echo head main; fi
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
source_options="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for tree in head main; do
    lock bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh" > "$out/build-$tree.log" 2>&1
    echo "build $tree: $?" >> "$out/progress"
done
for round in 1 2 3; do
    for run in "promote" "promote --after-scalar 200" "promote-scalar"; do
        name=$(echo "$run" | tr ' ' '_')
        script=""
        for tree in $(order $round); do
            script="$script cd ~/buster-fast-bench/claude-787/$tree && taskset -c 2 ./build/compiler benchmark-ir-source --only $run $source_options > $out/pair-$name-$tree-$round.log 2>&1; echo $name $tree $round \$?;"
        done
        lock bash -c "$script" >> "$out/pairs.log" 2>&1
        echo "pair $name $round: $?" >> "$out/progress"
    done
done
echo done >> "$out/progress"
