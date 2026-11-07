#!/bin/bash
# #1571 on benchpress (Ryzen 7 9700X): close/baked (main ec5f0f6b, built by close.sh) against the same revision with
# harness/1571.patch (the semantics initializer's guard on the mixed-input and assemble routes), built here by build.sh.
# Objects compared, then -c foo.s and a mixed C and assembly link timed against the other, two rounds, pinned to CPU 2.
# Every build and run takes the shared lock itself (exclusive.sh).
set -u
cd ~/buster-fast-bench/590-claude
export EXCLUSIVE_OWNER=claude-590 EXCLUSIVE_TITLE="#1571: semantics tables rebuilt for assembly inputs" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1571
ex=~/buster-fast-bench/exclusive.sh
work=close
log=$work/logs-1571
mkdir -p $log $work/objects-1571
printf '\t.text\n\t.globl\tadd_one\n\t.type\tadd_one, @function\nadd_one:\n\tleal\t1(%%rdi), %%eax\n\tret\n\t.size\tadd_one, .-add_one\n\t.section\t.note.GNU-stack,"",@progbits\n' > $work/inputs/foo.s
printf 'int add_one(int);\nint main(void) { return add_one(41) - 42; }\n' > $work/inputs/call.c
git -C $work/main checkout -q -- src && git -C $work/main apply ~/buster-fast-bench/590-claude/harness/1571.patch && git -C $work/main diff --stat > $log/patch.txt
(cd $work/main && $ex env BUSTER_DEBUG_INFO=0 ./build.sh) > $log/build.log 2>&1
cp $work/main/build/compiler $work/after1571
git -C $work/main checkout -q -- src
$ex $work/after1571 test-baked-tables > $log/test-baked-tables.txt 2>&1
sha256sum $work/baked $work/after1571 $work/inputs/foo.s $work/inputs/call.c harness/1571.patch > $log/hashes.txt
o=$work/objects-1571
$ex bash -c "d=0; for t in baked after1571; do $work/\$t -c $work/inputs/foo.s -o $o/foo-c.\$t.o && $work/\$t assemble $work/inputs/foo.s -o $o/foo-as.\$t.o && $work/\$t $work/inputs/call.c $work/inputs/foo.s -o $o/call.\$t.exe && $o/call.\$t.exe; echo \"\$t: status \$?\"; done; for f in foo-c foo-as; do cmp $o/\$f.baked.o $o/\$f.after1571.o || d=\$((d+1)); done; cmp $o/call.baked.exe $o/call.after1571.exe || d=\$((d+1)); echo \"outputs: 3 compared, \$d differ\"" > $log/objects.txt 2>&1
for round in 1 2; do
    $ex taskset -c 2 $(pwd)/$work/after1571 measure-compile --runs 41 --reference $(pwd)/$work/baked -- -c $work/inputs/foo.s > $log/foo-s-$round.txt 2>&1
    $ex taskset -c 2 $(pwd)/$work/after1571 measure-compile --runs 41 --reference $(pwd)/$work/baked -- $work/inputs/call.c $work/inputs/foo.s > $log/mixed-$round.txt 2>&1
done
echo done > $log/DONE
