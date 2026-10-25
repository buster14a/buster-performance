#!/bin/bash
# #426's default path on the 9700X: main, part 1 and two variants of it without the lowering's source tracking (v1: no
# per-task save and restore; v3: no source code in the lowering at all), each build and run under the lock on its own.
cd ~/buster-fast-bench/dwarf395/rows3 || exit 1
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_TITLE="#395 part 1: default-path variants" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/426
L=~/buster-fast-bench/exclusive.sh
root=$(pwd)
for t in v1 v3; do
    (cd $t && $L env LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh > $root/build-$t.log 2>&1); echo "build-$t $?"
done
$L bash -c 'for i in 1 2 3; do for t in main part1 v1 v3; do echo "== $t round $i"; perf stat -x, -e instructions:u,cycles:u -r 21 taskset -c 2 $t/build/compiler -o tmp/program-$t tmp/program.c 2>&1 >/dev/null | cut -d, -f1,3; done; done' > $root/perfstat-variants.log 2>&1; echo "perfstat $?"
part1/build/compiler ab --rounds 5 --cpu 2 --lock $L "$root/main" "$root/part1" "$root/v1" "$root/v3" -- time-runs --runs 21 --list -o "$root/tmp/program" "$root/tmp/program.c" > $root/ab-variants.log 2>&1; echo "ab $?"
echo done
