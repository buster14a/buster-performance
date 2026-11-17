head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== round 5: $(cat /proc/loadavg)" >> busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 >> busy.txt
for v in sum_fused_00 sum_fused_10 sum_fused_20 sum_fused_30 best_truth_00 best_truth_10 best_truth_20 best_truth_30 best_fused_00 best_fused_10 best_fused_20 best_fused_30 equal_truth_00 equal_truth_10 equal_truth_20 equal_truth_30 equal_fused_00 equal_fused_10 equal_fused_20 equal_fused_30 sum_truth_00 sum_truth_10 sum_truth_20 sum_truth_30; do
    taskset -c 2 ./diag $v > /dev/null
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o stat.csv ./diag $v > /dev/null
    s=$?
    printf '%s\t%s\t%s\t%s\t%s\n' 5 $v $(awk -F, '$3 ~ /^cycles/ { print $1 }' stat.csv) $(awk -F, '$3 ~ /^instructions/ { print $1 }' stat.csv) $s >> diag.tsv
done
