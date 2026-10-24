#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Exact CI command recipe for #335. The approved runner hook ALREADY holds the
# shared host lock for this job: never nest exclusive.sh here. Run from Buster's
# triggering checkout: bash /pinned/performance/handoff-335/ci/run.sh OUTPUT_DIR
set -euo pipefail
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
output=$1
fixture=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
mkdir -p "$output"
compiler=$(realpath build/compiler)
probe="$output/qualify"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
system=(-march=znver5 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
musl_flags=(-march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
{
    date -u --iso-8601=seconds
    git rev-parse HEAD
    git show --no-patch --format=raw HEAD
    uname -a
    lscpu
    clang --version
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/kernel/mm/transparent_hugepage/enabled
    cat /proc/self/status
    printf 'SOURCE_DATE_EPOCH=%s\n' "$SOURCE_DATE_EPOCH"
    printf 'Production build flags are recorded in compile_commands.json; probe uses the same host flags.\n'
} > "$output/provenance.txt"
git ls-files -z src build.sh | xargs -0 sha256sum > "$output/source.sha256"
sha256sum "$compiler" "$fixture/qualify.c" "$fixture/headers.c" "$fixture/run.sh" /usr/bin/clang > "$output/binaries-and-harness.sha256"
sha256sum "$corpus/sqlite/sqlite3.c" "$musl/src/stdio/vfprintf.c" > "$output/inputs.sha256"
cp "$corpus/README.txt" "$output/corpus-README.txt"
cp "$corpus/MANIFESTS.sha256" "$output/corpus-MANIFESTS.sha256"
cp build/compile_commands.json "$output/compile_commands.json"
timeout 60s clang -O3 -g -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Wno-unused-function -Isrc "$fixture/qualify.c" -lm -o "$probe" > "$output/probe-build.txt" 2>&1
sha256sum "$probe" >> "$output/binaries-and-harness.sha256"
timeout 60s "$compiler" test-profile > "$output/test-profile.txt" 2>&1
timeout 60s "$compiler" test-parser --clang > "$output/test-parser.txt" 2>&1
timeout 60s "$compiler" test-parser --clang -std=c99 > "$output/test-parser-c99.txt" 2>&1
timeout 60s "$compiler" test-parser --clang -std=c23 > "$output/test-parser-c23.txt" 2>&1
timeout 60s "$compiler" test-preprocessor --clang > "$output/test-preprocessor.txt" 2>&1
timeout 60s "$compiler" test-parser --clang "${system[@]}" "$corpus/sqlite/sqlite3.c" > "$output/test-parser-sqlite.txt" 2>&1
run_input()
{
    local name=$1
    shift
    timeout 60s "$compiler" test-preprocessor --compare-clang --clang /usr/bin/clang "$@" > "$output/oracle-$name.txt" 2>&1
    for driver in parse checker; do
        local command=(-fsyntax-only)
        [ "$driver" = parse ] && command=(parse -fsyntax-only)
        for spin in 0 200; do
            local log="$output/flag-$name-$driver-spin$spin.txt"
            for round in 1 2 3 4 5; do
                printf '== round %s, compiler %s, cpu 2; first list plain, second fused\n' "$round" "$compiler" >> "$log"
                timeout 45s taskset -c 2 "$compiler" time-runs --runs 21 --after-scalar "$spin" --list "${command[@]}" "$@" --list "${command[@]}" --parser-keywords "$@" >> "$log" 2>&1
            done
        done
    done
    for process in 1 2 3; do
        timeout 60s taskset -c 2 "$compiler" benchmark-parser "$@" > "$output/benchmark-$name-$process.txt" 2>&1
        timeout 60s taskset -c 2 "$probe" "$@" > "$output/accounting-$name-off-$process.txt" 2>&1
        timeout 60s taskset -c 2 "$probe" --parser-keywords "$@" > "$output/accounting-$name-on-$process.txt" 2>&1
    done
}
run_input small "${musl_flags[@]}" "$musl/src/stdio/vfprintf.c"
run_input headers "${system[@]}" "$fixture/headers.c"
run_input sqlite "${system[@]}" "$corpus/sqlite/sqlite3.c"
printf 'complete: 12 cells x 5 rounds x 21 paired fresh processes; three accounting/kernel processes per input\n' > "$output/COMPLETE.txt"
rm "$probe"
