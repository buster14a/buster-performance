#!/bin/bash
# where.sh OUT TREE UNIT...: where a musl unit's -c spends its user cycles in TREE's executable, by the link's sections:
# 100 runs a unit, each sampled every 10,007 + 2i cycles (perf record -e cycles:u, a period a run so that the runs
# don't sample the same instructions), the samples' addresses by section (the start order's .text.buster_start, the
# checker's .text.buster_checker, .text) and, for .text, by function. OUT/UNIT.txt.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
tree=$2
shift 2
mkdir -p "$out"
source ../scripts/musl-common.sh
cp "$tree/build/compiler" "$out/compiler"
readelf -SW "$out/compiler" | awk '$2 ~ /^\.text/ {print $2, $4, $6}' > "$out/sections.txt"
for unit in "$@"; do
    label=$(echo "$unit" | tr '/' '-' | sed 's/\.c$//')
    : > "$out/$label.samples"
    for ((i = 0; i < 100; i += 1)); do
        taskset -c 2 perf record -q -e cycles:u -c $((10007 + 2 * i)) -o "$out/sample.data" -- "$here/$out/compiler" "${options[@]}" -c "$musl/src/$unit" -o /dev/shm/2873-where.o > /dev/null 2>&1
        perf script -i "$out/sample.data" -F ip,sym 2> /dev/null >> "$out/$label.samples"
    done
    awk -v sections="$out/sections.txt" '
        BEGIN { while ((getline line < sections) > 0) { split(line, f, " "); n += 1; name[n] = f[1]; begin[n] = strtonum("0x" f[2]); end[n] = begin[n] + strtonum("0x" f[3]) } }
        {
            ip = strtonum("0x" $1); total += 1; where = "elsewhere"
            for (s = 1; s <= n; s += 1) if (ip >= begin[s] && ip < end[s]) where = name[s]
            count[where] += 1
            if (where == ".text") symbol[$2] += 1
        }
        END {
            printf "%d samples\n", total
            for (w in count) printf "  %-22s %6d  %5.1f%%\n", w, count[w], 100 * count[w] / total
            printf "the functions of .text:\n"
            for (s in symbol) printf "  %6d %5.2f%% %s\n", symbol[s], 100 * symbol[s] / total, s | "sort -rn | head -40"
        }' "$out/$label.samples" > "$out/$label.txt"
    rm -f "$out/$label.samples"
done
rm -f "$out/compiler" "$out/sample.data" /dev/shm/2873-where.o
head -60 "$out"/*.txt
