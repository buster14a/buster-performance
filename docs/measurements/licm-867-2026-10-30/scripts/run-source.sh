#!/usr/bin/env bash
set -euo pipefail
root=/home/david/buster-fast-bench/codex-pr915-20261030
mkdir -p "$root/results-source"
export EXCLUSIVE_OWNER=codex-pr915-source EXCLUSIVE_TITLE="PR915 source-derived LICM controls" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/915
for process in 1 2 3; do
    for shift in 0 64 128 192; do
        order=(source-base source-head)
        if (( (process + shift / 64) % 2 == 0 )); then order=(source-head source-base); fi
        for kind in loop nested noloop sqlite-normalize; do
            for variant in "${order[@]}"; do
                binary="$root/$variant/placements/compiler-$shift"
                log="$root/results-source/$variant-shift$shift-process$process-$kind.log"
                {
                    date --iso-8601=seconds
                    printf 'source-variant=%s placement=%s process=%s cpu=2 state=source-%s\n' "$variant" "$shift" "$process" "$kind"
                    sha256sum "$binary" "$root/$kind.c"
                    printf 'command=BUSTER_LICM_SOURCE=%s BUSTER_LICM_SOURCE_KIND=%s taskset -c 2 %s benchmark-ir-optimize-passes --pass licm --instructions 17 --samples 21\n' "$root/$kind.c" "$kind" "$binary"
                    "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_LICM_SOURCE="$root/$kind.c" BUSTER_LICM_SOURCE_KIND="$kind" taskset -c 2 "$binary" benchmark-ir-optimize-passes --pass licm --instructions 17 --samples 21
                } > "$log" 2>&1
                printf '%s\n' "$log"
            done
        done
    done
done
mkdir -p "$root/stats"
for variant in source-base source-head; do
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 "$root/$variant/placements/compiler-0" benchmark-ir-optimize-passes --pass licm --instructions 4096 --samples 1 > "$root/stats/$variant-long-chain.log" 2>&1
done
