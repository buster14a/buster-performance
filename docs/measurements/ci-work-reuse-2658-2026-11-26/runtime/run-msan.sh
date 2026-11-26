#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Local diagnostic replay of verified vector/O3/MSan products; not a Zen 5 benchmark.
# Usage: run-msan.sh CHECKOUT BINARY SERVER OUTPUT_DIRECTORY LABEL driver13|run-modes
set -euo pipefail

die() { printf 'run-msan: %s\n' "$*" >&2; exit 1; }
[[ $# == 6 ]] || die 'usage: run-msan.sh CHECKOUT BINARY SERVER OUTPUT_DIRECTORY LABEL driver13|run-modes'
checkout=$(realpath "$1")
binary=$(realpath "$2")
server=$(realpath "$3")
output=$(realpath -m "$4")
label=$5
mode=$6
[[ "$label" =~ ^[A-Za-z0-9._-]+$ ]] || die 'LABEL must contain only letters, digits, periods, underscores or hyphens'
[[ -x "$binary" && -x "$server" ]] || die 'BINARY and SERVER must be executable'
[[ -f "$checkout/tools/ci/sanitizers.sh" ]] || die 'CHECKOUT must contain tools/ci/sanitizers.sh'
case "$mode" in
    driver13) selection=(--part 13/16) ;;
    run-modes) selection=(--run-modes-only) ;;
    *) die 'MODE must be driver13 or run-modes' ;;
esac

# Put the shared official toolchain on PATH before invoking this script. The server also resolves its requests' clang
# through that PATH. Buster finds these headers through this explicit variable, not through PATH alone.
clang=$(command -v clang)
symbolizer=$(command -v llvm-symbolizer)
[[ $("$clang" -dumpversion) == 23.1.4 ]] || die 'PATH must select the verified Clang 23.1.4 toolchain'
[[ $("$server" --version) == 23.1.4 ]] || die 'SERVER must run and report Clang 23.1.4'
export BUSTER_CLANG_RESOURCE_DIR
BUSTER_CLANG_RESOURCE_DIR=$("$clang" -print-resource-dir)
[[ -f "$BUSTER_CLANG_RESOURCE_DIR/include/stddef.h" ]] || die 'the selected Clang resource directory lacks include/stddef.h'
taskset -c 0-3 true || die 'this replay requires CPUs 0-3, as the recorded pair did'

prefix="$output/$label"
report_root="$prefix-reports"
reports="$report_root/reports"
[[ "$reports" != *:* && "$reports" != *$'\n'* ]] || die 'OUTPUT_DIRECTORY cannot contain colons or newlines'
mkdir -p "$output"
for path in "$prefix.log" "$prefix.time" "$prefix.audit.log" "$prefix.meta" "$prefix.status" "$report_root"; do
    [[ ! -e "$path" ]] || die "refusing to overwrite $path; choose a new LABEL"
done
mkdir -p "$reports"
cache=$(mktemp -d "${TMPDIR:-/tmp}/buster-2658-msan-cache.XXXXXXXX")
trap 'rm -rf -- "$cache"' EXIT
export XDG_CACHE_HOME="$cache"
export BUSTER_ORACLE_CACHE=check
export MSAN_SYMBOLIZER_PATH="$symbolizer"
export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
unset CPATH C_INCLUDE_PATH
command=("$binary" test-checker-driver --executable "$binary" "${selection[@]}" --in-process --clang-server "$server")
{
    printf 'label\t%s\nmode\t%s\ncheckout\t%s\n' "$label" "$mode" "$checkout"
    printf 'checkout_revision\t%s\n' "$(git -C "$checkout" rev-parse HEAD)"
    printf 'affinity\t0-3\nclang\t%s\nsymbolizer\t%s\n' "$clang" "$symbolizer"
    printf 'resource_directory\t%s\ncache\t%s\noracle_cache\tcheck\n' "$BUSTER_CLANG_RESOURCE_DIR" "$XDG_CACHE_HOME"
    printf 'MSAN_OPTIONS\t%s\nSOURCE_DATE_EPOCH\t%s\n' "$MSAN_OPTIONS" "${SOURCE_DATE_EPOCH-<unset>}"
    printf 'kernel\t%s\n' "$(uname -r)"
    printf 'command\t'; printf '%q ' taskset -c 0-3 "${command[@]}"; printf '\n'
    sha256sum "$binary" "$server" "$checkout/tools/ci/sanitizers.sh" "$checkout/tests/driver/run_modes.c"
} > "$prefix.meta"

cd "$checkout"
TIMEFORMAT='wall=%3R user=%3U sys=%3S'
status=0
{ time taskset -c 0-3 "${command[@]}" > "$prefix.log" 2>&1; } 2> "$prefix.time" || status=$?
printf 'exit=%s\n' "$status" >> "$prefix.time"
audit=0
bash tools/ci/sanitizers.sh audit "$reports" > "$prefix.audit.log" 2>&1 || audit=$?
eligible=no
if [[ "$status" == 0 && "$audit" == 0 ]]; then eligible=yes; fi
printf 'run_exit\t%s\naudit_exit\t%s\neligible\t%s\n' "$status" "$audit" "$eligible" > "$prefix.status"
cat "$prefix.time" "$prefix.status"
if [[ "$status" != 0 ]]; then exit "$status"; fi
exit "$audit"
