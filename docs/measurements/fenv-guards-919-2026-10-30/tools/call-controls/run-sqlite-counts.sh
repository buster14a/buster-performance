#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# One exact non-timed shipping/probe compile per source; no sampled stacks.
set -euo pipefail
base=$(realpath -- "${1:?usage: run-sqlite-counts.sh BASE_SHIPPING HEAD_SHIPPING BASE_PROBE HEAD_PROBE VALIDATE_COUNTS CORPUS NEW_OUTPUT}")
head=$(realpath -- "${2:?}")
base_probe=$(realpath -- "${3:?}")
head_probe=$(realpath -- "${4:?}")
reader=$(realpath -- "${5:?}")
corpus=$(realpath -- "${6:?}")
output=${7:?}
test ! -e "$output"
mkdir -p "$output"
output=$(realpath -- "$output")
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$corpus/sqlite/sqlite3.c" \
    a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33 "$corpus/provenance/gnu17-pinned-predefines.txt" \
    > "$output/expected-frozen-inputs.sha256"
sha256sum --check "$output/expected-frozen-inputs.sha256" > "$output/frozen-input-check.txt"
sha256sum "$base" "$head" "$base_probe" "$head_probe" "$reader" "$(realpath -- "$0")" \
    "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > "$output/before-counts.sha256"
find -L "$corpus/headers" -type f -print0 | sort -z | xargs -0 sha256sum >> "$output/before-counts.sha256"
arguments=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
    --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
    -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
date -u '+before_count_compiles_utc=%Y-%m-%dT%H:%M:%SZ' > "$output/execution-receipt.txt"
for revision in base head; do
    shipping=$base
    probe=$base_probe
    if [[ "$revision" = head ]]; then shipping=$head; probe=$head_probe; fi
    stem="$output/$revision-sqlite"
    printf '%s\0' "$shipping" "${arguments[@]}" -o "$stem.shipping.o" > "$stem.shipping.argv0"
    taskset -c 2 "$shipping" "${arguments[@]}" -o "$stem.shipping.o" > "$stem.shipping.stdout" 2> "$stem.shipping.stderr"
    printf '%s\0' "$probe" "${arguments[@]}" -o "$stem.probe.o" > "$stem.probe.argv0"
    taskset -c 2 "$probe" "${arguments[@]}" -o "$stem.probe.o" > "$stem.probe.stdout" 2> "$stem.probe.stderr"
    cmp "$stem.shipping.stdout" "$stem.probe.stdout"
    sed '/^buster919-fenv /d' "$stem.probe.stderr" > "$stem.filtered.stderr"
    cmp "$stem.shipping.stderr" "$stem.filtered.stderr"
    cmp "$stem.shipping.o" "$stem.probe.o"
    printf '%s SQLite shipping/probe status0 and object/stdout/diagnostic parity PASS\n' "$revision"
done
cmp "$output/base-sqlite.shipping.o" "$output/head-sqlite.shipping.o"
"$reader" off "$output/base-sqlite.probe.stderr" "$output/head-sqlite.probe.stderr" > "$output/sqlite-counts.json"
date -u '+after_count_compiles_utc=%Y-%m-%dT%H:%M:%SZ' >> "$output/execution-receipt.txt"
sha256sum --check "$output/before-counts.sha256" > "$output/after-counts-check.txt"
sha256sum "$output"/*.o > "$output/object-sha256.txt"
printf 'Frozen SQLite ACCESS-off helper calls eliminated; all shipping/probe parity gates passed.\n'
