#!/bin/bash
# Compiles sn.c with each tree's Tier 0 (and the fix's --tier1, and clang -O0), then times each executable's run,
# interleaved, 15 rounds, pinned to CPU 2, under one hold of the 9700X lock (one measurement run).
set -e
D=~/buster-fast-bench/3308-claude
cd $D
base/build/compiler sn.c -o sn-base
fix/build/compiler sn.c -o sn-fix
fix/build/compiler --tier1 sn.c -o sn-tier1
clang -O0 sn.c -o sn-clang-O0
for e in sn-base sn-fix sn-tier1 sn-clang-O0; do echo "$e: $(./$e)"; done
objdump -d --no-show-raw-insn sn-base | awk '/<A>:/,/ret/' > A-base.s
objdump -d --no-show-raw-insn sn-fix | awk '/<A>:/,/ret/' > A-fix.s
export EXCLUSIVE_OWNER=claude-3308 EXCLUSIVE_TITLE="buster #3308: Tier 0 zeroes int-to-float destinations" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3308
~/buster-fast-bench/exclusive.sh bash -c '
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
for r in $(seq 1 15); do
  for e in sn-base sn-fix sn-tier1 sn-clang-O0; do
    s=$(date +%s%N); timeout 30 taskset -c 2 ./$e > /dev/null; t=$(date +%s%N)
    echo "$r $e $(( (t - s) / 1000 ))"
  done
done
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6' > times.log 2>&1
awk "NF==3 && \$2 ~ /^sn-/ {k=\$2; v=\$3; if (!(k in best) || v < best[k]) best[k]=v; sum[k]+=v; n[k]++} END {for (k in best) printf \"%s best %.1f ms mean %.1f ms\n\", k, best[k]/1000, sum[k]/n[k]/1000}" times.log | sort
