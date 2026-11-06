#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 signed-offset validation' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
(cd affine && "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 8) > affine-build.log 2>&1
set +e
(cd affine && "$HOME/buster-fast-bench/exclusive.sh" ./build/compiler test-tier1-select) > affine-select.log 2>&1
status=$?
printf '%s\n' "$status" > affine-recheck.done
exit "$status"
