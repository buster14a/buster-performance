#!/bin/bash
# #871 prefetch-qualification campaign: interleaved perf-stat runs over
# hint-family variants and workloads. Usage: run-campaign.sh "workloads" REPS
# Each run takes the whole CSV row set of one perf group on one variant.
set -u
cd "$HOME/buster-fast-bench/devin-871"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
M=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/libc/musl
G=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/musl-generated/obj
OUT=measure-871/runs.csv
workloads="$1"
reps="$2"
[ -f "$OUT" ] || echo "rep,workload,variant,group,event,value" > "$OUT"
variants=(all none seq ind nonodes)
EVA="cycles,instructions,ls_pref_instr_disp.all,ls_inef_sw_pref.all,ls_sw_pf_dc_fills.all,ls_hw_pf_dc_fills.all"
EVB="cycles,instructions,ls_alloc_mab_count,de_no_dispatch_per_slot.backend_stalls,ls_inef_sw_pref.data_pipe_sw_pf_dc_hit,ls_inef_sw_pref.mab_mch_cnt"
for w in $workloads; do
    for rep in $(seq 1 "$reps"); do
        for k in 0 1 2 3 4; do
            v="${variants[$(((k + rep) % ${#variants[@]}))]}"
            for g in A B; do
                case $g in
                    A) ev="$EVA" ;;
                    B) ev="$EVB" ;;
                esac
                case $w in
                    pp)  cmd=(./variants/compiler-$v -E -P "$C") ;;
                    syn) cmd=(./variants/compiler-$v -fsyntax-only "$C") ;;
                    cc)  cmd=(./variants/compiler-$v -c "$C" -o /tmp/m871-$v.o) ;;
                    hdr) cmd=(bash -c "while read -r f; do \"$PWD/variants/compiler-$v\" -E -P -I$M/src/include -I$M/include -I$M/arch/x86_64 -I$M/arch/generic -I$G/include \"\$f\" >/dev/null 2>&1; done < $PWD/measure-871/musl-files.txt") ;;
                    *) echo "unknown workload $w" >&2; exit 2 ;;
                esac
                s=$(date +%s%N)
                perf stat -x, -e "$ev" -- taskset -c 2 "${cmd[@]}" > /dev/null 2> /tmp/m871-stat.csv
                e=$(date +%s%N)
                echo "$rep,$w,$v,$g,wall_ns,$((e - s))" >> "$OUT"
                grep -vE '^(#|$)' /tmp/m871-stat.csv | awk -F, -v pre="$rep,$w,$v,$g" 'NF >= 3 { print pre "," $3 "," $1 }' >> "$OUT"
            done
        done
    done
done
echo "done $workloads x$reps"
