#!/bin/bash
# diag.sh ROUNDS: builds diag (clang -O2) and times its twenty variants per round in one hold of the 9700X's lock, CPU 2,
# perf stat cycles:u and instructions:u; the variants' order rotates by round. Results: diag.tsv.
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2791 EXCLUSIVE_TITLE="#2791 Tier 1: a select of a floating comparison is ucomis and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2791
bash gen.sh > loops.s
clang -O2 -o diag diag.c loops.s || exit 1
objdump -d --no-show-raw-insn diag | awk '/<v_.*>:/,/ret/' > diag.s
variants=""
for v in equal_main equal_fused equal_own count_main count_head; do for o in 00 10 20 30; do variants="$variants ${v}_$o"; done; done
for v in $variants; do ./diag $v; done | sort -u | awk 'END { if (NR != 2) { print "outputs differ"; exit 1 } }' || exit 1
printf 'round\tvariant\tcycles\tinstructions\tstatus\n' > diag.tsv
for round in $(seq 1 "$1"); do
    all=($variants); r=$(( (round - 1) % 20 )); order="${all[*]:r} ${all[*]:0:r}"
    cat > round.sh <<ROUND
head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== round $round: \$(cat /proc/loadavg)" >> busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 >> busy.txt
for v in $order; do
    taskset -c 2 ./diag \$v > /dev/null
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o stat.csv ./diag \$v > /dev/null
    s=\$?
    printf '%s\t%s\t%s\t%s\t%s\n' $round \$v \$(awk -F, '\$3 ~ /^cycles/ { print \$1 }' stat.csv) \$(awk -F, '\$3 ~ /^instructions/ { print \$1 }' stat.csv) \$s >> diag.tsv
done
ROUND
    ~/buster-fast-bench/exclusive.sh timeout -k 5 180 bash round.sh 2>> lock.log
done
echo done > diag.done
