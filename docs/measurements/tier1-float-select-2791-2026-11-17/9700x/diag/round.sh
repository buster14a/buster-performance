head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== round 5: $(cat /proc/loadavg)" >> busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 >> busy.txt
for v in equal_fused_00 equal_fused_10 equal_fused_20 equal_fused_30 equal_own_00 equal_own_10 equal_own_20 equal_own_30 count_main_00 count_main_10 count_main_20 count_main_30 count_head_00 count_head_10 count_head_20 count_head_30 equal_main_00 equal_main_10 equal_main_20 equal_main_30; do
    taskset -c 2 ./diag $v > /dev/null
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o stat.csv ./diag $v > /dev/null
    s=$?
    printf '%s\t%s\t%s\t%s\t%s\n' 5 $v $(awk -F, '$3 ~ /^cycles/ { print $1 }' stat.csv) $(awk -F, '$3 ~ /^instructions/ { print $1 }' stat.csv) $s >> diag.tsv
done
