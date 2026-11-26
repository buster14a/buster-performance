set -euo pipefail
evidence="$(realpath -m evidence-3645)"
mkdir -p "$evidence"
printf '%s\n' "base=$(git -C base rev-parse HEAD)" "head=$(git -C pr3645 rev-parse HEAD)" > "$evidence/identity.txt"
clang --version >> "$evidence/identity.txt"
sha256sum base/build/compiler pr3645/build/compiler >> "$evidence/identity.txt"
root=fp-fold-harness/docs/measurements/tier1-fma-memory-2829-2026-11-20
bash "$root/build-kernels.sh" "$(realpath base/build/compiler)" "$(realpath pr3645/build/compiler)"
taskset -c 2 bash "$root/verify-programs.sh" > "$evidence/digests.tsv"
cd "$root"
sha256sum kernels/* programs/*.o >> "$evidence/identity.txt"
size programs/*.o > "$evidence/sizes.txt"
cat /proc/loadavg > "$evidence/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-before.txt"
printf '%s\n' 'round target mode pad side kernel elements reps wall_ns_per_element cycles_per_element instructions_per_element' > "$evidence/kernels.txt"
for round in 0 1 2; do
    order=(base head)
    if ((round % 2)); then order=(head base); fi
    for arch in x86-64 znver5; do
        for mode in default unroll; do
            for pad in 0 16 32 48; do
                for kernel in saxpy_f32 dot_f32 matmul_f32 i32_to_f32; do
                    reps=65536
                    if [[ "$kernel" == matmul_f32 ]]; then reps=4096; fi
                    for side in "${order[@]}"; do
                        row="$evidence/$round-$arch-$mode-$pad-$kernel-$side.csv"
                        perf_log="$row.perf"
                        LC_ALL=C taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u -o "$perf_log" -- "./programs/$side-$arch-$mode-p$pad" "$kernel" "$reps" > "$row"
                        read -r _ elements _ _ wall digest < "$row"
                        expected=$(awk -v name="$kernel" -v target="$arch" '$1 == name && $2 == target { print $6; exit }' "$evidence/digests.tsv")
                        [[ -n "$expected" ]]
                        test "$digest" = "$expected"
                        counters=$(awk -F, -v n="$((reps * elements))" '
                            $3 ~ /^(cycles|instructions):u$/ && $1 ~ /^[0-9]+$/ { v[$3] = $1 / n }
                            END {
                                if (v["cycles:u"] <= 0 || v["instructions:u"] <= 0) exit 1
                                printf "%.6f %.6f", v["cycles:u"], v["instructions:u"]
                            }' "$perf_log")
                        printf '%s %s %s %s %s %s %s %s %s %s\n' "$round" "$arch" "$mode" "$pad" "$side" "$kernel" "$elements" "$reps" "$wall" "$counters" >> "$evidence/kernels.txt"
                    done
                done
            done
        done
    done
done
cat /proc/loadavg > "$evidence/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-after.txt"
cat "$evidence/kernels.txt"
