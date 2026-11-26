#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Reproduce generated C and permanent fixture semantic checks. All generated files stay in OUTPUT.
set -euo pipefail
here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo=$(realpath "${1:?usage: bash run-source.sh CHECKOUT HEAD_COMPILER OUTPUT [BASE_COMPILER]}")
compiler=$(realpath "${2:?head compiler required}")
mkdir -p "${3:?output directory required}"
out=$(realpath "$3")
baseline=${4:-}
if [[ -n $baseline ]]; then baseline=$(realpath "$baseline"); fi
clang=${BUSTER_VALIDATION_CLANG:-clang}
"$clang" -std=c11 -O2 -Wall -Wextra -Werror "$here/validate1384.c" -o "$out/validate1384"
"$clang" -std=c17 -O2 -Wall -Wextra -Werror -c "$here/frame-mutate.c" -o "$out/frame-mutate.o"
sha256sum "$compiler" > "$out/head-compiler.sha256"
: > "$out/head-semantic-results.tsv"
cd "$repo"
for count in 64 1536 8000; do
    "$out/validate1384" generate frame "$count" "$out/frame-$count.c"
    "$out/validate1384" reference frame "$count" "$out/frame-$count-reference.c"
    "$out/validate1384" driver "$count" "$out/driver-$count.c"
    "$clang" -std=c17 -O2 -c "$out/frame-$count-reference.c" -o "$out/frame-$count-reference.o"
    "$clang" -std=c17 -O2 -c "$out/driver-$count.c" -o "$out/driver-$count.o"
    "$clang" -std=c17 -O2 -Dh_bytes=observe_bytes -c "$out/driver-$count.c" -o "$out/driver-$count-mutate.o"
    "$clang" -no-pie "$out/driver-$count.o" "$out/frame-$count-reference.o" -o "$out/frame-$count-reference"
    "$out/frame-$count-reference" > "$out/frame-$count-reference.out"
    "$clang" -no-pie "$out/driver-$count-mutate.o" "$out/frame-mutate.o" "$out/frame-$count-reference.o" -o "$out/frame-$count-reference-mutate"
    "$out/frame-$count-reference-mutate" > "$out/frame-$count-reference-mutate.out"
    verify=(--verify)
    if [[ -n $baseline && $count != 64 ]]; then
        if "$out/validate1384" run "$out/frame-$count-baseline.json" "$baseline" --lanes 1 -std=c17 --tier1 --tier1-strict --tier1-report -c "$out/frame-$count.c" -o "$out/frame-$count-baseline.o" > "$out/frame-$count-baseline.compile.log" 2>&1; then
            printf 'Unexpected baseline success at %s\n' "$count" >&2
            exit 1
        else
            status=$?
            test "$status" -eq 1
            rg -q 'cause=cfg-allocation error=2' "$out/frame-$count-baseline.compile.log"
        fi
    fi
    "$out/validate1384" run "$out/frame-$count-head.json" "$compiler" --lanes 1 -std=c17 --tier1 --tier1-strict --tier1-report "${verify[@]}" -c "$out/frame-$count.c" -o "$out/frame-$count-head.o" > "$out/frame-$count-head.compile.log" 2>&1
    for field in tier1=1 compiled=1 code_certified=1 code_uncertified=0 fallbacks=0 resource_failures=0; do
        rg -q "(^|[[:space:]])$field([[:space:]]|$)" "$out/frame-$count-head.compile.log"
    done
    "$clang" -no-pie "$out/driver-$count.o" "$out/frame-$count-head.o" -o "$out/frame-$count-head"
    "$out/frame-$count-head" > "$out/frame-$count-head.out"
    cmp "$out/frame-$count-reference.out" "$out/frame-$count-head.out"
    "$clang" -no-pie "$out/driver-$count-mutate.o" "$out/frame-mutate.o" "$out/frame-$count-head.o" -o "$out/frame-$count-head-mutate"
    "$out/frame-$count-head-mutate" > "$out/frame-$count-head-mutate.out"
    cmp "$out/frame-$count-reference-mutate.out" "$out/frame-$count-head-mutate.out"
    printf '%s\tread-only and mutating callees match independent reference\n' "$count" | tee -a "$out/head-semantic-results.tsv"
done
"$clang" -std=c17 -O2 -Wall -Wextra -Werror -c tests/driver/tier1_frame_scopes_main.c -o "$out/frame-scopes-driver.o"
"$clang" -std=c17 -O2 -DBUSTER_FRAME_REFERENCE tests/driver/tier1_frame_scopes.c "$out/frame-scopes-driver.o" -o "$out/frame-scopes-reference"
"$out/frame-scopes-reference" > "$out/frame-scopes-reference.out"
for mode in remat no-remat; do
    options=()
    if [[ $mode == no-remat ]]; then options=(--tier1-no-rematerialize); fi
    "$out/validate1384" run "$out/frame-scopes-head-$mode.json" "$compiler" --lanes 1 -std=c17 --tier1 --tier1-strict --tier1-report --verify "${options[@]}" -c tests/driver/tier1_frame_scopes.c -o "$out/frame-scopes-head-$mode.o" > "$out/frame-scopes-head-$mode.compile.log" 2>&1
    for field in tier1=1 compiled=1 code_certified=1 code_uncertified=0 fallbacks=0 resource_failures=0; do
        rg -q "(^|[[:space:]])$field([[:space:]]|$)" "$out/frame-scopes-head-$mode.compile.log"
    done
    "$clang" -no-pie "$out/frame-scopes-driver.o" "$out/frame-scopes-head-$mode.o" -o "$out/frame-scopes-head-$mode"
    "$out/frame-scopes-head-$mode" > "$out/frame-scopes-head-$mode.out"
    cmp "$out/frame-scopes-reference.out" "$out/frame-scopes-head-$mode.out"
    printf 'permanent-1536-%s\t' "$mode" | tee -a "$out/head-semantic-results.tsv"
    cat "$out/frame-scopes-head-$mode.out" | tee -a "$out/head-semantic-results.tsv"
done
sha256sum "$out"/frame-64.c "$out"/frame-1536.c "$out"/frame-8000.c "$out"/*reference.c "$out"/driver-*.c > "$out/generated-source.sha256"
sha256sum "$out"/*.out > "$out/runtime-outputs.sha256"
