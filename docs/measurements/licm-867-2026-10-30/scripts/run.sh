#!/usr/bin/env bash
set -euo pipefail
root=/home/david/buster-fast-bench/codex-pr915-20261030
mkdir -p "$root/results"
export EXCLUSIVE_OWNER=codex-pr915 EXCLUSIVE_TITLE="PR915 LICM acceptance" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/915
run()
{
    local variant=$1 shift=$2 process=$3 length=$4 state=$5
    local log="$root/results/$variant-shift$shift-process$process-length$length-$state.log"
    local binary="$root/$variant/placements/compiler-$shift"
    local expected=6
    if [[ $state == isolated || $state == after-scalar ]]; then expected=3; fi
    if [[ -f $log && $(grep -c '^ir-pass licm .* samples=' "$log" || true) == "$expected" ]]; then
        printf 'retained %s\n' "$log"
        return
    fi
    local args=(benchmark-ir-optimize-passes --pass licm --instructions "$length" --samples 21)
    if [[ $state == isolated ]]; then args+=(--only vector); fi
    if [[ $state == after-scalar ]]; then args+=(--only vector --after-scalar 200); fi
    {
        date --iso-8601=seconds
        printf 'source-variant=%s placement=%s process=%s cpu=2 state=%s\n' "$variant" "$shift" "$process" "$state"
        sha256sum "$binary"
        printf 'command=taskset -c 2 %q' "$binary"
        printf ' %q' "${args[@]}"
        printf '\n'
        "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 "$binary" "${args[@]}"
    } > "$log" 2>&1
    printf '%s\n' "$log"
}
for process in 1 2 3; do
    for shift in 0 64 128 192; do
        order=(base head)
        if (( (process + shift / 64) % 2 == 0 )); then order=(head base); fi
        for length in 4096 255 17; do
            for variant in "${order[@]}"; do run "$variant" "$shift" "$process" "$length" interleaved; done
        done
        for variant in "${order[@]}"; do run "$variant" "$shift" "$process" 4096 isolated; done
    done
done
for shift in 0 128; do
    for variant in base head; do run "$variant" "$shift" 1 4096 after-scalar; done
done
