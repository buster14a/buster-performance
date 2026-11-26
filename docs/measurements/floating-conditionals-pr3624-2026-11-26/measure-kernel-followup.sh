set -euo pipefail
pr=$1
evidence="evidence-${pr#pr}"
mkdir -p "$evidence"
cat /proc/loadavg > "$evidence/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-before.txt"
for march in znver5 x86-64; do
    for side in base head; do
        compiler=base/build/compiler
        if [[ "$side" == head ]]; then compiler="$pr/build/compiler"; fi
        case "$pr" in
            pr3635)
                "$compiler" --tier1 --tier1-strict --verify -O2 "-march=$march" -Dmain=copy_correctness -c pr3635/tests/tier1/copy-halves.c -o "$evidence/$side-$march.o"
                clang -O2 -no-pie copy-pair-driver.c "$evidence/$side-$march.o" -o "$evidence/$side-$march"
                ;;
            pr3624)
                "$compiler" --tier1 --tier1-strict --tier1-passes=-vectorize -O2 "-march=$march" -c conditional-kernels.c -o "$evidence/$side-$march.o"
                clang -O2 -no-pie conditional-driver.c "$evidence/$side-$march.o" -o "$evidence/$side-$march"
                ;;
            pr3652)
                if [[ "$side" == base ]]; then compiler=base3652/build/compiler; fi
                for tier in tier0 tier1; do
                    options=()
                    if [[ "$tier" == tier1 ]]; then options=(--tier1 --tier1-report); fi
                    "$compiler" "${options[@]}" "-march=$march" asm-goto.c -o "$evidence/$side-$march-$tier" > "$evidence/$side-$march-$tier.report" 2>&1
                done
                ;;
        esac
    done
done
printf '%s\n' 'target workload round side user_cycles user_instructions branch_misses' > "$evidence/results.txt"
for march in znver5 x86-64; do
    cases=(64-built 128-built 256-built 64-cold 128-cold 256-cold)
    if [[ "$pr" == pr3624 ]]; then cases=(dboth both); fi
    if [[ "$pr" == pr3652 ]]; then cases=(tier0 tier1); fi
    for workload in "${cases[@]}"; do
        for round in 0 1 2 3 4; do
            order=(base head)
            if (( round % 2 )); then order=(head base); fi
            for side in "${order[@]}"; do
                path="$evidence/$side-$march"
                options=("$workload")
                if [[ "$pr" == pr3652 ]]; then
                    path+="-$workload"
                    options=(50000000)
                fi
                log="$evidence/$march-$workload-$round-$side"
                taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,branch-misses:u -o "$log.csv" -- "./$path" "${options[@]}" > "$log.out"
                tail -1 "$log.out" > "$log.digest"
                counters=$(awk -F, '$3 ~ /^(cycles|instructions|branch-misses):u$/ && $1 ~ /^[0-9]+$/ { values[$3]=$1 }
                    END { if (length(values) != 3) exit 1; print values["cycles:u"], values["instructions:u"], values["branch-misses:u"] }' "$log.csv")
                printf '%s %s %s %s %s\n' "$march" "$workload" "$round" "$side" "$counters" >> "$evidence/results.txt"
            done
            cmp "$evidence/$march-$workload-$round-base.digest" "$evidence/$march-$workload-$round-head.digest"
        done
    done
done
cat /proc/loadavg > "$evidence/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-after.txt"
