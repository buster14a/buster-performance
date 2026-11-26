set -euo pipefail
round=$1
evidence="evidence-3626/round-$round"
mkdir -p "$evidence"
mapfile -t files < <(sed -n 's|^\([0-9][0-9]*\)$|c-testsuite/tests/single-exec/\1.c|p' pr3626/tests/c-testsuite/subset.txt)
[[ ${#files[@]} == 220 ]]
cat /proc/loadavg > "$evidence/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-before.txt"
order=(base pr3626)
if ((round % 2)); then order=(pr3626 base); fi
for workload in 00040 full; do
    inputs=(c-testsuite/tests/single-exec/00040.c)
    if [[ "$workload" == full ]]; then inputs=("${files[@]}"); fi
    for side in "${order[@]}"; do
        prefix="$evidence/$workload-$side"
        mkdir -p "$prefix-tmp"
        TMPDIR="$(realpath "$prefix-tmp")" taskset -c 2 perf stat --no-big-num -x, -e cycles:u,cycles:k,instructions:u,minor-faults -o "$prefix.csv" -- "$side/build/compiler" test-ssa-source --typed --tier1 --keep "${inputs[@]}" > "$prefix.out" 2> "$prefix.err"
        awk -v expected="${#inputs[@]}" '
            /^test-ssa-source: totals / {
                count++
                for (i = 3; i <= NF; i++) { split($i, f, "="); a[f[1]] = f[2] }
                bad = a["programs"] != expected || a["passed"] != expected || a["native_programs"] != expected ||
                      a["native_passed"] != expected || a["left_out"] != 0 || a["failed"] != 0 || a["failures"] != 0
            }
            END { exit count != 1 || bad }
        ' "$prefix.out"
        kept=$(find "$prefix-tmp" -mindepth 1 -maxdepth 1 -type d -name 'ssa-source-*')
        (cd "$kept" && find . -mindepth 2 -maxdepth 2 -type f \( -path './run-*-memory/ssa-source.out' -o -path './run-*-ssa/ssa-source.out' -o -path './run-*-typed/ssa-source.out' -o -path './run-*-tier1-vector/output' -o -path './run-*-tier1-scalar/output' \) -print0 | sort -z | xargs -0 -r sha256sum) > "$prefix.outputs.sha256"
        test "$(wc -l < "$prefix.outputs.sha256")" -eq "$(("${#inputs[@]}" * 5))"
        grep '^test-ssa-source: totals ' "$prefix.out"
        rm -r "$prefix-tmp"
    done
    cmp "$evidence/$workload-base.outputs.sha256" "$evidence/$workload-pr3626.outputs.sha256"
done
cat /proc/loadavg > "$evidence/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-after.txt"
