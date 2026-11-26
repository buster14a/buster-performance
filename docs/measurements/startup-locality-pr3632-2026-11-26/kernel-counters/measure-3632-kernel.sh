set -euo pipefail
out=evidence-3632-kernel
mkdir -p "$out"
printf 'int add_one(int x) { return x + 1; }\n' > "$out/tiny.c"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sqlite_flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
cat /proc/loadavg > "$out/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-before.txt"
printf '%s\n' 'workload mode round side user_cycles kernel_cycles minor_faults' > "$out/results.txt"
for workload in tiny sqlite; do
    flags=("$out/tiny.c")
    if [[ "$workload" == sqlite ]]; then flags=("${sqlite_flags[@]}"); fi
    for mode in default full; do
        mode_flags=()
        if [[ "$mode" == full ]]; then mode_flags=(--no-direct); fi
        for round in $(seq 0 40); do
            order=(base pr3632)
            if (( round % 2 )); then order=(pr3632 base); fi
            for side in "${order[@]}"; do
                statfile="$out/$workload-$mode-$round-$side.csv"
                taskset -c 2 perf stat --no-big-num -x, -e cycles:u,cycles:k,minor-faults -o "$statfile" -- "$side/build/compiler" -c "${flags[@]}" "${mode_flags[@]}" -o "$out/$side.o"
                counters=$(awk -F, '$3 ~ /^(cycles:[uk]|minor-faults)$/ && $1 ~ /^[0-9]+$/ { v[$3] = $1 }
                    END { if (length(v) != 3 || v["cycles:k"] <= 0) exit 1; print v["cycles:u"], v["cycles:k"], v["minor-faults"] }' "$statfile")
                printf '%s %s %s %s %s\n' "$workload" "$mode" "$round" "$side" "$counters" >> "$out/results.txt"
            done
            cmp "$out/base.o" "$out/pr3632.o"
        done
    done
done
cat /proc/loadavg > "$out/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-after.txt"
