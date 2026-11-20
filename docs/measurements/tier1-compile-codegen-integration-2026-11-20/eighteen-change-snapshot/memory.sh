#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);d="$w/eighteen-evidence/memory";mkdir -p "$d"
export BUSTER_SANITIZER=memory BUSTER_SANITIZER_OPTIMIZATION=1 BUSTER_HOST_ARCH=znver5 BUSTER_TEST_HOST_BUSY=0
export PATH=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH CORES_LINK=https://github.com/buster14a/buster/pull/3136
cd "$w/eighteen-msan"
CORES_TITLE='Build the eighteen-PR compiler with MemorySanitizer' cores -n 2 -- ./build.sh --config Release >"$d/build.log" 2>&1
GITHUB_ENV="$d/settings.env" bash tools/ci/sanitizers.sh configure "$d/reports" >"$d/configure.log" 2>&1
while IFS= read -r setting;do export "$setting";done <"$d/settings.env"
for t in test-tier1-wide test-tier1-emit test-tier1-select test-tier1-pipeline test-ir-inline test-check-debug;do
 args=("$t");[[ $t != test-check-debug ]] || args+=(--cross-check)
 set +e;CORES_TITLE="Check integrated compiler with MemorySanitizer ($t)" cores -n 1 -- ./build/compiler "${args[@]}" >"$d/$t.log" 2>&1;rc=$?;set -e
 echo "$rc" >"$d/$t.status"
done
set +e;bash tools/ci/sanitizers.sh audit "$d/reports" >"$d/audit.log" 2>&1;rc=$?;set -e;echo "$rc" >"$d/audit.status"
touch "$d/complete"
