#!/usr/bin/env bash
set -euo pipefail
root=/home/david/buster-fast-bench/codex-pr915-20261030
for variant in base head source-base source-head; do
    for symbol in ir_optimize_licm ir_licm_worklist ir_pass_benchmark_repeat; do
        read -r original size type name < <(nm -S --defined-only "$root/$variant/placements/compiler-0" | awk -v name="$symbol" '$4 == name')
        test "$name" = "$symbol"
        for shift in 0 64 128 192; do
            read -r address shifted_size shifted_type shifted_name < <(nm -S --defined-only "$root/$variant/placements/compiler-$shift" | awk -v name="$symbol" '$4 == name')
            test "$shifted_name" = "$symbol"
            test "$size" = "$shifted_size"
            test "$((16#$address - 16#$original))" -eq "$shift"
            printf '%s shift=%s symbol=%s address=%s size=%s movement=%s\n' "$variant" "$shift" "$symbol" "$address" "$size" "$((16#$address - 16#$original))"
        done
    done
done
