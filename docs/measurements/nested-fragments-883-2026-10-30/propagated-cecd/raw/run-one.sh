#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -uo pipefail
qual_root=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-propagated-qualification
qual_mode=${1:?ordinary, address or thread required}
qual_arch=${2:?native or baseline required}
case "$qual_mode-$qual_arch" in
    ordinary-native|ordinary-baseline|address-native|address-baseline|thread-native) ;;
    *) echo 'unsupported qualification role' >&2; exit 2 ;;
esac
qual_role="$qual_mode-$qual_arch"
qual_receipt="$qual_root/$qual_role"
qual_snapshot="$qual_root/snapshot-$qual_role"
test -s "$qual_root/commit.txt" || exit 2
test -s "$qual_receipt/source.sha256" || exit 2
test ! -e "$qual_receipt/build.status" || exit 2
test ! -e "$qual_receipt/status.txt" || exit 2
command -v cores > /dev/null || exit 2
cd "$qual_snapshot" || exit 2
sha256sum -c "$qual_receipt/source.sha256" > "$qual_receipt/source-before.verify"
qual_before_rc=$?
printf 'source_before=%s\n' "$qual_before_rc" > "$qual_receipt/status.txt"
if [ "$qual_before_rc" -ne 0 ]; then exit 1; fi
unset CPATH C_INCLUDE_PATH BUSTER_HOST_RUNTIME BUSTER_FUZZ_AVAILABLE BUSTER_FUZZ_ENTRY BUSTER_ORACLE_CACHE BUSTER_TEST_NO_LANE_THREADS
unset ASAN_OPTIONS LSAN_OPTIONS UBSAN_OPTIONS TSAN_OPTIONS MSAN_OPTIONS
unset ASAN_SYMBOLIZER_PATH MSAN_SYMBOLIZER_PATH BUSTER_SANITIZER_REPORTS
export BUSTER_HOST_ARCH=native BUSTER_LINKER=lld BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER_OPTIMIZATION=3
if [ "$qual_arch" = baseline ]; then export BUSTER_HOST_ARCH=x86-64; fi
export BUSTER_SANITIZER=none
if [ "$qual_mode" != ordinary ]; then export BUSTER_SANITIZER="$qual_mode"; fi
mkdir -p "$qual_receipt/tmp" "$qual_receipt/reports"
export TMPDIR="$qual_receipt/tmp"
clang --version > "$qual_receipt/compiler-version.txt"
./build.sh print-compile-flags > "$qual_receipt/compile-flags.nul"
qual_flags_rc=$?
printf 'flags=%s\n' "$qual_flags_rc" >> "$qual_receipt/status.txt"
if [ "$qual_flags_rc" -ne 0 ]; then exit 1; fi
if [ "$qual_mode" != ordinary ]; then
    export GITHUB_ENV="$qual_receipt/sanitizer.env"
    : > "$GITHUB_ENV"
    bash tools/ci/sanitizers.sh configure "$qual_receipt/reports" > "$qual_receipt/configure.log" 2>&1
    qual_configure_rc=$?
    printf 'configure=%s\n' "$qual_configure_rc" >> "$qual_receipt/status.txt"
    if [ "$qual_configure_rc" -ne 0 ]; then exit 1; fi
    set -a
    source "$GITHUB_ENV"
    set +a
    CORES_TITLE="883 propagated $qual_role detector proof" CORES_LINK=https://github.com/buster14a/buster/pull/883 \
        cores -n 1 -- bash "$qual_root/with-cores.sh" "$qual_receipt" probe bash tools/ci/sanitizers.sh probe "$qual_receipt/probes"
    qual_probe_rc=$?
    printf 'probe=%s\n' "$qual_probe_rc" >> "$qual_receipt/status.txt"
    if [ "$qual_probe_rc" -ne 0 ]; then exit 1; fi
fi
CORES_TITLE="883 propagated $qual_role O3 build" CORES_LINK=https://github.com/buster14a/buster/pull/883 \
    cores -n 2 -- bash "$qual_root/with-cores.sh" "$qual_receipt" build ./build.sh
qual_build_rc=$?
printf 'build=%s\n' "$qual_build_rc" >> "$qual_receipt/status.txt"
if [ "$qual_build_rc" -ne 0 ]; then exit 1; fi
cp build/compile_commands.json "$qual_receipt/compile_commands.json" || exit 1
sha256sum build/compiler > "$qual_receipt/binary.sha256" || exit 1
qual_units=$(wc -l < "$qual_receipt/compile_commands.json")
qual_o3=$(grep -c '"-O3"' "$qual_receipt/compile_commands.json")
qual_instrumented=$qual_units
if [ "$qual_mode" = address ]; then
    qual_instrumented=$(grep -c -- '-fsanitize=address,undefined,bounds' "$qual_receipt/compile_commands.json")
elif [ "$qual_mode" = thread ]; then
    qual_instrumented=$(grep -c -- '-fsanitize=thread' "$qual_receipt/compile_commands.json")
fi
printf 'units=%s\no3_units=%s\ninstrumented_units=%s\n' "$qual_units" "$qual_o3" "$qual_instrumented" > "$qual_receipt/metadata-counts.txt"
if [ "$qual_units" -ne 41 ] || [ "$qual_o3" -ne 41 ] || [ "$qual_instrumented" -ne 41 ]; then
    printf 'metadata=1\n' >> "$qual_receipt/status.txt"
    exit 1
fi
printf 'metadata=0\n' >> "$qual_receipt/status.txt"
qual_test=(./build/compiler test-checker --seed 133)
qual_cores=3
if [ "$qual_mode" = thread ]; then
    qual_test=(./build/compiler test-check-units --keep)
    qual_cores=3
fi
CORES_TITLE="883 propagated $qual_role full focused check" CORES_LINK=https://github.com/buster14a/buster/pull/883 \
    cores -n "$qual_cores" -- bash "$qual_root/with-cores.sh" "$qual_receipt" checker timeout 1800 "${qual_test[@]}"
qual_checker_rc=$?
printf 'checker=%s\n' "$qual_checker_rc" >> "$qual_receipt/status.txt"
qual_audit_rc=0
if [ "$qual_mode" != ordinary ]; then
    bash tools/ci/sanitizers.sh audit "$qual_receipt/reports" > "$qual_receipt/audit.log" 2>&1
    qual_audit_rc=$?
    printf 'audit=%s\n' "$qual_audit_rc" >> "$qual_receipt/status.txt"
fi
sha256sum -c "$qual_receipt/source.sha256" > "$qual_receipt/source-after.verify"
qual_after_rc=$?
sha256sum -c "$qual_receipt/binary.sha256" > "$qual_receipt/binary-after.verify"
qual_binary_rc=$?
printf 'source_after=%s\nbinary_after=%s\n' "$qual_after_rc" "$qual_binary_rc" >> "$qual_receipt/status.txt"
cat "$qual_receipt/status.txt"
if [ "$qual_checker_rc" -ne 0 ] || [ "$qual_audit_rc" -ne 0 ] || [ "$qual_after_rc" -ne 0 ] || [ "$qual_binary_rc" -ne 0 ]; then exit 1; fi
