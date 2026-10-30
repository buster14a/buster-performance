#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Non-timed compile/output/call-receipt checks. Run under the shared host lock.
set -euo pipefail
base=$(realpath -- "${1:?usage: run-controls.sh BASE_SHIPPING HEAD_SHIPPING BASE_PROBE HEAD_PROBE VALIDATE_COUNTS OFFICIAL_CLANG NEW_OUTPUT}")
head=$(realpath -- "${2:?}")
base_probe=$(realpath -- "${3:?}")
head_probe=$(realpath -- "${4:?}")
reader=$(realpath -- "${5:?}")
clang=$(realpath -- "${6:?}")
output=${7:?}
fixtures=$(cd -- "$(dirname -- "$0")" && pwd)
test ! -e "$output"
mkdir -p "$output"
output=$(realpath -- "$output")
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
sha256sum "$base" "$head" "$base_probe" "$head_probe" "$reader" "$clang" "$fixtures"/*.c "$fixtures/run-controls.sh" > "$output/before-controls.sha256"
date -u '+before_controls_utc=%Y-%m-%dT%H:%M:%SZ' > "$output/execution-receipt.txt"
for path in vector scalar; do
    options=()
    if [[ "$path" = scalar ]]; then options=(--scalar); fi
    for fixture in tiny-off tiny-on tiny-scope invalid-off invalid-on strict-rounding; do
        expected=0
        if [[ "$fixture" = invalid-* ]]; then expected=1; fi
        for revision in base head; do
            shipping=$base
            probe=$base_probe
            if [[ "$revision" = head ]]; then shipping=$head; probe=$head_probe; fi
            stem="$output/$fixture-$path-$revision"
            status_shipping=0
            taskset -c 2 "$shipping" "${options[@]}" -c -std=gnu17 -march=znver5 "$fixtures/$fixture.c" -o "$stem.shipping.o" > "$stem.shipping.stdout" 2> "$stem.shipping.stderr" || status_shipping=$?
            status_probe=0
            taskset -c 2 "$probe" "${options[@]}" -c -std=gnu17 -march=znver5 "$fixtures/$fixture.c" -o "$stem.probe.o" > "$stem.probe.stdout" 2> "$stem.probe.stderr" || status_probe=$?
            test "$status_shipping" = "$expected"
            test "$status_probe" = "$expected"
            cmp "$stem.shipping.stdout" "$stem.probe.stdout"
            sed '/^buster919-fenv /d' "$stem.probe.stderr" > "$stem.filtered.stderr"
            cmp "$stem.shipping.stderr" "$stem.filtered.stderr"
            if [[ "$expected" = 0 ]]; then
                cmp "$stem.shipping.o" "$stem.probe.o"
            else
                test ! -e "$stem.shipping.o"
                test ! -e "$stem.probe.o"
            fi
            printf '%s %s %s shipping_status=%s probe_status=%s parity=PASS\n' "$fixture" "$path" "$revision" "$status_shipping" "$status_probe"
        done
        if [[ "$expected" = 0 ]]; then
            cmp "$output/$fixture-$path-base.shipping.o" "$output/$fixture-$path-head.shipping.o"
        fi
        mode=on
        case "$fixture" in
            tiny-off|invalid-off) mode=off ;;
            tiny-scope) mode=mixed ;;
            invalid-on) mode=invalid-on ;;
            strict-rounding) mode=mixed ;;
        esac
        "$reader" "$mode" "$output/$fixture-$path-base.probe.stderr" "$output/$fixture-$path-head.probe.stderr" > "$output/$fixture-$path.counts.json"
    done
done
"$clang" -std=c17 -O2 -c "$fixtures/rounding-oracle.c" -o "$output/rounding-oracle.o"
for fixture in tiny-off tiny-on tiny-scope strict-rounding; do
    for path in vector scalar; do
        for revision in base head; do
            stem="$output/$fixture-$path-$revision"
            objects=("$stem.shipping.o")
            if [[ "$fixture" = strict-rounding ]]; then objects+=("$output/rounding-oracle.o"); fi
            "$clang" "${objects[@]}" -lm -o "$stem.run"
            taskset -c 2 "$stem.run"
            printf '%s %s %s linked_runtime_status=0\n' "$fixture" "$path" "$revision"
        done
    done
done
date -u '+after_controls_utc=%Y-%m-%dT%H:%M:%SZ' >> "$output/execution-receipt.txt"
sha256sum --check "$output/before-controls.sha256" > "$output/after-controls-check.txt"
printf 'All scalar/vector shipping/probe output, ACCESS count and linked runtime gates passed.\n'
