#!/bin/bash
# counters.sh ROUNDS VARIANT...: the frozen sqlite3.c's -c (one lane) and -fsyntax-only, perf stat per process, the
# variants in an order that rotates by round, pinned to CPU 2. Run under exclusive.sh (one hold for the campaign).
cd ~/buster-fast-bench/1555-claude/run || exit 2
source ../main/tools/microarch/workloads.sh
SCRATCH=scratch
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
rounds=$1; shift
variants=("$@")
n=${#variants[@]}
EV=cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_misal_loads.ma4k:u,ls_dispatch.ld_dispatch:u
out=results/counters-$(date +%H%M%S).csv
echo "round,variant,workload,event,value" > $out
for r in $(seq $rounds); do
    for i in $(seq 0 $((n - 1))); do
        v=${variants[$(( (i + r) % n ))]}
        for w in sq-c sq-syn; do
            workload "$v" "$w"
            perf stat -x, -o scratch/stat.csv -e $EV taskset -c 2 "${WL[@]}" > /dev/null 2> scratch/stderr-$v-$w.txt || echo "FAILED $v $w round $r"
            awk -F, -v r=$r -v v=$v -v w=$w 'NF > 3 && $1 ~ /^[0-9]/ { print r "," v "," w "," $3 "," $1 }' scratch/stat.csv >> $out
        done
    done
done
echo "wrote $out"
# Medians per variant, workload and event.
awk -F, 'NR > 1 { k = $2 "," $3 "," $4; vals[k] = vals[k] " " $5 } END { for (k in vals) print k, vals[k] }' $out | sort | while read -r k rest; do
    printf '%s median %s\n' "$k" "$(echo $rest | tr ' ' '\n' | sort -n | awk '{ a[NR] = $1 } END { print (NR % 2) ? a[(NR + 1) / 2] : (a[NR / 2] + a[NR / 2 + 1]) / 2 }')"
done
