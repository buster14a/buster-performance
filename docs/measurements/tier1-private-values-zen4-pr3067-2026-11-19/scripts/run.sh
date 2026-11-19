#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Fresh source-to-object pairs, using one hardware thread of each physical core.
set -euo pipefail
record=$(cd "$(dirname "$0")/.." && pwd)
base=$(realpath "${1:?baseline compiler}")
candidate=$(realpath "${2:?candidate compiler}")
frozen=$(realpath "${3:?frozen corpus root}")
lua=$(realpath "${4:?Lua 5.4.8 src directory}")
corpus=${5:?sqlite, lua or musl}
cpus=${6:?CPU IDs separated by commas}
out=$(realpath -m "${7:?output directory}")
rounds=${8:-12}
IFS=, read -r -a cpu_array <<< "$cpus"
cores=${#cpu_array[@]}
mkdir -p "$out"
mkdir "$out/objects"
command -v perf >/dev/null
tool="$out/measure"
cc -O2 -o "$tool" "$record/scripts/measure.c"
sys=(-nostdinc)
for dir in usr/lib/clang/23/include usr/local/include usr/include; do
    if [[ -d "$frozen/headers/$dir" ]]; then sys+=(-isystem "$frozen/headers/$dir"); fi
done
case "$corpus" in
    sqlite) src="$frozen/sqlite"; flags=(-std=gnu17 "${sys[@]}") ;;
    lua) src="$lua"; flags=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "${sys[@]}") ;;
    musl)
        src="$frozen/libc/musl"
        gen="$frozen/musl-generated/obj"
        flags=(-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700
               "-I$src/arch/x86_64" "-I$src/arch/generic" "-I$gen/src/internal"
               "-I$src/src/include" "-I$src/src/internal" "-I$gen/include" "-I$src/include")
        ;;
    *) exit 2 ;;
esac
mapfile -t files < <(awk -F '\t' -v root="$src" 'NR>1 { print root "/" $1 }' "$record/inputs/$corpus.inputs.tsv")
bytes=$(awk -F '\t' 'NR>1{ n+=$2 } END{ print n }' "$record/inputs/$corpus.inputs.tsv")
export LC_ALL=C SOURCE_DATE_EPOCH=1700000000 BUSTER_EXIT_HELPER=0 BUSTER_HUGE_PAGES=1 BUSTER_TEST_HOST_BUSY=0
printf '%s\n' 'round,position,mode,case,cores,source_bytes,wall_ms,user_ms,sys_ms,minor_faults,major_faults,involuntary,peak_rss_kib,cycles_u,instructions_u,branches_u,branch_misses_u,min_run_pct' > "$out/runs.csv"
cd "$out/objects"
for ((r=0;r<=rounds;r++)); do
    if ((r%2)); then arms=(candidate base); else arms=(base candidate); fi
    for pos in 0 1; do
        mode=${arms[pos]}
        exe=$base
        if [[ $mode = candidate ]]; then exe=$candidate; fi
        rm -f ./*.o
        taskset -c "$cpus" perf stat --no-big-num -x ';' -o "$out/current.perf" -e '{cycles:u,instructions:u,branches:u,branch-misses:u}' -- "$tool" "$out/elapsed" "$exe" --lanes "$cores" --lane-cpus "$cpus" --tier1 -c "${flags[@]}" "${files[@]}" > "$out/stdout" 2> "$out/stderr"
        objects=(*.o)
        [[ ${#objects[@]} = ${#files[@]} && -f ${objects[0]} ]]
        counts=$(awk -F ';' '$3 ~ /^(cycles:u|instructions:u|branches:u|branch-misses:u)$/ { if ($1 !~ /^[0-9]+$/ || $5+0 < 98) bad=1; n++; a[$3]=$1; if (!min || $5+0<min) min=$5+0 } END {if (bad||n!=4) exit 1; printf "%s,%s,%s,%s,%.2f", a["cycles:u"],a["instructions:u"],a["branches:u"],a["branch-misses:u"],min}' "$out/current.perf")
        elapsed=$(tr ' ' ',' < "$out/elapsed")
        printf '%s,%s,%s,%s,%s,%s,%s,%s\n' "$r" "$pos" "$mode" "$corpus" "$cores" "$bytes" "$elapsed" "$counts" >> "$out/runs.csv"
    done
done
