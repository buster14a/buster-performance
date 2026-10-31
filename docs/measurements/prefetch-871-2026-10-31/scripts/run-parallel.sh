#!/bin/bash
# #871: 1/2/4/8 concurrent -c workers on all vs nonodes + UMC counters.
# Usage: run-parallel.sh
set -u
cd "$HOME/buster-fast-bench/devin-871"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
OUT=measure-871/parallel.csv
[ -f "$OUT" ] || echo "bin,workers,rep,wall_ms,umc_rd,umc_wr" > "$OUT"
declare -A BINS=( [all]=compiler-all [nonodes]=compiler-nonodes )
for rep in 1 2; do
    for workers in 1 2 4 8; do
        for name in all nonodes; do
            b="$PWD/variants/${BINS[$name]}"
            s=$(date +%s%N)
            BIN="$b" SRC="$C" W="$workers" perf stat -a -x, -e amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/ -- bash -c '
                pids=()
                for cpu in $(seq 2 $((W + 1))); do
                    taskset -c $cpu "$BIN" -c "$SRC" -o /tmp/m871-p$cpu.o > /dev/null 2>&1 &
                    pids+=($!)
                done
                for p in "${pids[@]}"; do wait $p; done
            ' > /dev/null 2> /tmp/m871-par.csv
            e=$(date +%s%N)
            rd=$(awk -F, '$3 ~ /umc_cas_cmd.rd/ {print $1}' /tmp/m871-par.csv | tr -d ' ')
            wr=$(awk -F, '$3 ~ /umc_cas_cmd.wr/ {print $1}' /tmp/m871-par.csv | tr -d ' ')
            echo "$name,$workers,$rep,$(( (e-s)/1000000 )),${rd:-0},${wr:-0}" >> "$OUT"
        done
    done
done
echo done-parallel
