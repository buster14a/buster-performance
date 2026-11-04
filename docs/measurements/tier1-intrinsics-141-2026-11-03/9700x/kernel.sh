#!/usr/bin/env bash
# kernel.sh: kernel.c (pdep, pext, bextr and bzhi in a loop) by clang -O2, and by each tree's --tier1 -march=native
# (main's leaves its functions with the builtins to Tier 0, the head's takes them), each tree's Tier 0 too; their
# outputs compared, then perf stat of each, 11 runs a hold, 3 rounds in a rotating order, pinned to CPU 2 (kernel/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p kernel
"$lock" bash -c "clang --version | head -1 > kernel/clang.txt; clang -O2 -march=native -o $RUNDIR/k-clang-O2 kernel.c"
for t in $TREES; do
    "$lock" bash -c "$t/build/compiler -march=native --tier1 --tier1-report --tier1-refusals -o $RUNDIR/k-$t-tier1 kernel.c > kernel/build-$t-tier1.txt 2>&1; echo \"exit \$?\" >> kernel/build-$t-tier1.txt"
    "$lock" bash -c "$t/build/compiler -march=native -o $RUNDIR/k-$t-tier0 kernel.c > kernel/build-$t-tier0.txt 2>&1; echo \"exit \$?\" >> kernel/build-$t-tier0.txt"
done
programs=(k-clang-O2)
for t in $TREES; do programs+=(k-$t-tier0 k-$t-tier1); done
for p in "${programs[@]}"; do
    "$lock" bash -c "taskset -c 2 $RUNDIR/$p > kernel/output-$p.txt 2>&1; echo \"exit \$?\" >> kernel/output-$p.txt"
    objdump -d --no-show-raw-insn $RUNDIR/$p | awk '/<(morton_encode|morton_x|morton_y|fields|main)>:/,/^$/' > kernel/disassembly-$p.txt
done
{ for p in "${programs[@]}"; do echo "$p $(sha256sum < kernel/output-$p.txt | cut -c1-16)"; done; } > kernel/outputs.txt
for r in 1 2 3; do
    for k in "${!programs[@]}"; do
        p=${programs[$(( (k + r) % ${#programs[@]} ))]}
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 -o $PWD/kernel/stat-$p-$r.csv $RUNDIR/$p > /dev/null"
    done
done
touch kernel/done
