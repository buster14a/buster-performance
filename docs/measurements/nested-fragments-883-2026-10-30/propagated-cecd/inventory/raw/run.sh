#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -uo pipefail
inv_root=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-cecd-inventory
inv_trace="$inv_root/trace-cecd4962"
inv_qual=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-propagated-qualification
inv_untraced="$inv_qual/snapshot-address-native"
inv_corpus=/home/david/.cache/claude-frozen-corpus
cd "$inv_root" || exit 2
test -f "$inv_root/SETUP-REVIEW-CLEAR.txt" || exit 2
test ! -e "$inv_root/run.started" || exit 2
sha256sum -c "$inv_root/setup.sha256" > "$inv_root/setup-before-run-check.log" || exit 2
printf 'one fresh cecd diagnostic/comparison invocation\n' > "$inv_root/run.started"
unset CPATH C_INCLUDE_PATH BUSTER_HOST_RUNTIME BUSTER_FUZZ_AVAILABLE BUSTER_FUZZ_ENTRY BUSTER_ORACLE_CACHE BUSTER_TEST_NO_LANE_THREADS
unset ASAN_OPTIONS LSAN_OPTIONS UBSAN_OPTIONS TSAN_OPTIONS MSAN_OPTIONS ASAN_SYMBOLIZER_PATH MSAN_SYMBOLIZER_PATH BUSTER_SANITIZER_REPORTS
export BUSTER_HOST_ARCH=native BUSTER_SANITIZER=none BUSTER_DEBUG_INFO=0 BUSTER_LINKER=lld SOURCE_DATE_EPOCH=1792454400
unset BUSTER_SANITIZER_OPTIMIZATION
mkdir -p "$inv_root/tmp"
export TMPDIR="$inv_root/tmp"
cd "$inv_trace" || exit 2
printf 'phase\texit\n' > "$inv_root/status.tsv"
./build.sh print-compile-flags > "$inv_root/trace-compile-flags.argv0"
inv_rc=$?; printf 'trace-flags\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
./build.sh print-sources > "$inv_root/trace-build-sources.argv0"
inv_rc=$?; printf 'trace-sources\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
clang -march=native -Isrc -dM -E -include src/buster/compiler/host_isa.h -x c /dev/null > "$inv_root/host-vector.txt"
inv_rc=$?; printf 'host-vector-query\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ] || ! rg -qx '#define BUSTER_HOST_VECTOR 1' "$inv_root/host-vector.txt"; then exit 1; fi
CORES_TITLE='883 cecd non-timing trace build' CORES_LINK=https://github.com/buster14a/buster/pull/883 \
    cores -n 2 -- bash "$inv_root/with-cores.sh" "$inv_root" trace-build ./build.sh
inv_rc=$?; printf 'trace-build\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
cp build/compile_commands.json "$inv_root/trace-compile_commands.json" || exit 1
sha256sum build/compiler > "$inv_root/trace-compiler.sha256" || exit 1
CORES_TITLE='883 cecd inventory aggregator build' CORES_LINK=https://github.com/buster14a/buster/pull/883 \
    cores -n 1 -- bash "$inv_root/with-cores.sh" "$inv_root" aggregator-build clang -std=c17 -O2 -Wall -Wextra -Werror "$inv_root/fragment-inventory.c" -o "$inv_root/fragment-inventory"
inv_rc=$?; printf 'aggregator-build\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
sha256sum -c "$inv_root/source.trace.sha256" > "$inv_root/trace-source-after-build-check.log"
inv_rc=$?; printf 'trace-source-after-build\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
sha256sum -c "$inv_root/input-identities.sha256" > "$inv_root/input-before-compile-check.log"
inv_rc=$?; printf 'inputs-before-compile\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
(
cd "$inv_corpus"
sha256sum -c "$inv_root/frozen-headers.sha256"
) > "$inv_root/headers-before-compile-check.log"
inv_rc=$?; printf 'headers-before-compile\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
CORES_TITLE='883 cecd SQLite attempted-root diagnostic' CORES_LINK=https://github.com/buster14a/buster/pull/883 \
    cores -n 1 -- bash "$inv_root/compile-one.sh" trace
inv_rc=$?; printf 'trace-compile\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
"$inv_root/fragment-inventory" "$inv_root/sqlite.trace" > "$inv_root/sqlite.inventory.tsv" 2> "$inv_root/aggregation.stderr"
inv_rc=$?; printf 'aggregation\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
sha256sum -c "$inv_root/untraced-compiler.sha256" > "$inv_root/untraced-binary-before-run-check.log"
inv_rc=$?; printf 'untraced-binary-before-run\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
mkdir -p "$inv_root/untraced-qualification/reports"
export GITHUB_ENV="$inv_root/untraced-qualification/github.env" BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=3
: > "$GITHUB_ENV"
bash "$inv_untraced/tools/ci/sanitizers.sh" configure "$inv_root/untraced-qualification/reports" > "$inv_root/untraced-qualification/configure.log" 2>&1
inv_rc=$?; printf 'untraced-configure\t%s\n' "$inv_rc" >> "$inv_root/status.tsv"
if [ "$inv_rc" -ne 0 ]; then exit 1; fi
set -a
source "$GITHUB_ENV"
set +a
CORES_TITLE='883 cecd matched-source untraced SQLite compile' CORES_LINK=https://github.com/buster14a/buster/pull/883 \
    cores -n 1 -- bash "$inv_root/compile-one.sh" untraced
inv_untraced_rc=$?; printf 'untraced-compile\t%s\n' "$inv_untraced_rc" >> "$inv_root/status.tsv"
bash "$inv_untraced/tools/ci/sanitizers.sh" audit "$inv_root/untraced-qualification/reports" > "$inv_root/untraced-qualification/audit.log" 2>&1
inv_audit_rc=$?; printf 'untraced-audit\t%s\n' "$inv_audit_rc" >> "$inv_root/status.tsv"
sha256sum -c "$inv_root/source.trace.sha256" > "$inv_root/trace-source-after-run-check.log"
inv_trace_rc=$?; printf 'trace-source-after-run\t%s\n' "$inv_trace_rc" >> "$inv_root/status.tsv"
(
cd "$inv_untraced"
sha256sum -c "$inv_qual/address-native/source.sha256"
) > "$inv_root/untraced-source-after-run-check.log"
inv_source_rc=$?; printf 'untraced-source-after-run\t%s\n' "$inv_source_rc" >> "$inv_root/status.tsv"
(
cd "$inv_corpus"
sha256sum -c "$inv_root/frozen-headers.sha256"
) > "$inv_root/input-headers-after-run-check.log"
inv_headers_rc=$?; printf 'headers-after-run\t%s\n' "$inv_headers_rc" >> "$inv_root/status.tsv"
sha256sum -c "$inv_root/input-identities.sha256" > "$inv_root/input-after-run-check.log"
inv_input_rc=$?; printf 'inputs-after-run\t%s\n' "$inv_input_rc" >> "$inv_root/status.tsv"
sha256sum -c "$inv_root/trace-compiler.sha256" > "$inv_root/trace-binary-after-run-check.log"
inv_trace_binary_rc=$?; printf 'trace-binary-after-run\t%s\n' "$inv_trace_binary_rc" >> "$inv_root/status.tsv"
sha256sum -c "$inv_root/untraced-compiler.sha256" > "$inv_root/untraced-binary-after-run-check.log"
inv_untraced_binary_rc=$?; printf 'untraced-binary-after-run\t%s\n' "$inv_untraced_binary_rc" >> "$inv_root/status.tsv"
if [ "$inv_untraced_rc" -ne 0 ] || [ "$inv_audit_rc" -ne 0 ] || [ "$inv_trace_rc" -ne 0 ] || [ "$inv_source_rc" -ne 0 ] || [ "$inv_headers_rc" -ne 0 ] || [ "$inv_input_rc" -ne 0 ] || [ "$inv_trace_binary_rc" -ne 0 ] || [ "$inv_untraced_binary_rc" -ne 0 ]; then exit 1; fi
cmp "$inv_root/sqlite.trace.o" "$inv_root/sqlite.untraced.o" > "$inv_root/object-comparison.stdout" 2> "$inv_root/object-comparison.stderr"
inv_cmp_rc=$?; printf 'object-comparison\t%s\n' "$inv_cmp_rc" >> "$inv_root/status.tsv"
printf '%s\n' "$inv_cmp_rc" > "$inv_root/object-comparison.status"
sha256sum "$inv_root/sqlite.trace" "$inv_root/sqlite.inventory.tsv" "$inv_root/sqlite.trace.o" "$inv_root/sqlite.untraced.o" > "$inv_root/result-identities.sha256"
cat "$inv_root/status.tsv"
exit "$inv_cmp_rc"
