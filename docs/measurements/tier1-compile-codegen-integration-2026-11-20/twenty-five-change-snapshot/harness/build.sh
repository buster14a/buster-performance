#!/usr/bin/env bash
set -euo pipefail
w=$(cd "$(dirname "$0")/.." && pwd);cd "$w";dest="$w/final-evidence";variant=$1;dir="final-$variant"
cd "$dir"
export BUSTER_HOST_ARCH=znver5
if [[ $variant == asan ]]; then export BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=1;fi
export CORES_LINK=https://github.com/buster14a/buster/pull/3144 CORES_TITLE="Build the final-change combined compiler ($variant)"
set +e
cores -n 2 -- ./build.sh --config Release >"$dest/$variant-build.log" 2>&1;rc=$?;echo "$rc" >"$dest/$variant-build.status";exit "$rc"
