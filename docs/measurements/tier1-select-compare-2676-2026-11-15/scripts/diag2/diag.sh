#!/bin/bash
# diag.sh ROUNDS: builds diag (clang -O2) and times its twelve variants per round in one hold of the 9700X's lock, CPU 2,
# perf stat cycles:u and instructions:u; the variants' order rotates by round. Results: diag.tsv.
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2676 EXCLUSIVE_TITLE="#2676 Tier 1: a select of a comparison is cmp and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2676
clang -O2 -o diag diag.c loops.s || exit 1
objdump -d --no-show-raw-insn diag | awk '/<v_.*>:/,/ret/' > diag.s
variants="head_00 head_10 head_20 head_30 nomov_00 nomov_10 nomov_20 nomov_30 main_00 main_10 main_20 main_30"
for v in $variants; do ./diag $v; done | sort -u | awk 'END { if (NR != 1) { print "outputs differ"; exit 1 } }' || exit 1
printf 'round\tvariant\tcycles\tinstructions\tstatus\n' > diag.tsv
for round in $(seq 1 "$1"); do
    all=($variants); r=$(( (round - 1) % 12 )); order="${all[*]:r} ${all[*]:0:r}"
    cat > round.sh <<ROUND
head -1 /var/lib/buster-9700x/owner >> holds.txt
for v in $order; do
    taskset -c 2 ./diag \$v > /dev/null
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o stat.csv ./diag \$v > /dev/null
    s=\$?
    printf '%s\t%s\t%s\t%s\t%s\n' $round \$v \$(awk -F, '\$3 ~ /^cycles/ { print \$1 }' stat.csv) \$(awk -F, '\$3 ~ /^instructions/ { print \$1 }' stat.csv) \$s >> diag.tsv
done
ROUND
    ~/buster-fast-bench/exclusive.sh timeout -k 5 120 bash round.sh 2>> lock.log
done
echo done > diag.done
