head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== round 5: $(cat /proc/loadavg)" >> busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> busy.txt
for k in null best equal sum lt eq ne; do
    for b in base head always o2 ; do
        taskset -c 2 ./bench_$b $k > /dev/null
        start=$(date +%s%N)
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u -o stat.csv ./bench_$b $k > /dev/null
        status=$?
        end=$(date +%s%N)
        c=$(awk -F, '$3 ~ /^cycles/ { print $1 }' stat.csv)
        i=$(awk -F, '$3 ~ /^instructions/ { print $1 }' stat.csv)
        m=$(awk -F, '$3 ~ /^branch-misses/ { print $1 }' stat.csv)
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' 5 $k $b $c $i $m $(( end - start )) $status >> results.tsv
    done
done
echo "== after round 5: $(cat /proc/loadavg)" >> busy.txt
