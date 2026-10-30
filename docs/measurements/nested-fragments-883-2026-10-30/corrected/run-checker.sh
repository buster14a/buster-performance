#!/usr/bin/env bash
set -euo pipefail
architecture=$1
tree=$2
output=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-fullsan/corrected/$architecture
mkdir -p "$output"
cd "$tree"
unset CPATH C_INCLUDE_PATH BUSTER_HOST_RUNTIME BUSTER_FUZZ_AVAILABLE BUSTER_FUZZ_ENTRY BUSTER_ORACLE_CACHE
export BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=lld
if [ "$architecture" = native ]; then
    export BUSTER_HOST_ARCH=native
else
    export BUSTER_HOST_ARCH=x86-64
fi
export GITHUB_ENV="$output/sanitizer.env"
: > "$GITHUB_ENV"
bash tools/ci/sanitizers.sh configure "$output/reports"
set -a
source "$GITHUB_ENV"
set +a
checker_status=0
CORES_TITLE="PR 883 full checker $architecture sanitizer validation" CORES_LINK='https://github.com/buster14a/buster/pull/883' \
    cores -n 2 -- timeout 1800 ./build/compiler test-checker --seed 133 > "$output/checker.log" 2>&1 || checker_status=$?
audit_status=0
bash tools/ci/sanitizers.sh audit "$output/reports" > "$output/audit.log" 2>&1 || audit_status=$?
printf 'checker=%s audit=%s\n' "$checker_status" "$audit_status" | tee "$output/status.txt"
if [ "$checker_status" -ne 0 ] || [ "$audit_status" -ne 0 ]; then exit 1; fi
