#!/usr/bin/env bash
set -u
d=$(cd "$(dirname "$0")" && pwd);cd "$d/../final-asan"
export PATH=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH BUSTER_HOST_ARCH=znver5 BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=1 BUSTER_TEST_HOST_BUSY=0
file="$d/sanitizer.env";: >"$file";GITHUB_ENV="$file" bash tools/ci/sanitizers.sh configure "$d/sanitizer-reports" || exit 1
while IFS= read -r setting; do export "$setting";done < "$file"
export CORES_TITLE='Run the combined compiler with AddressSanitizer and UndefinedBehaviorSanitizer' CORES_LINK=https://github.com/buster14a/buster/pull/3144
for t in test-tier1-emit test-tier1-select test-tier1-wide test-tier1-pipeline test-ir-inline test-check-debug;do
 args=("$t");[[ $t != test-check-debug ]] || args+=(--cross-check)
 cores -n 1 -- ./build/compiler "${args[@]}" >"$d/asan-$t.log" 2>&1;echo "$?" >"$d/asan-$t.status"
done
bash tools/ci/sanitizers.sh audit "$d/sanitizer-reports" >"$d/asan-audit.log" 2>&1;echo $? >"$d/asan-audit.status"
