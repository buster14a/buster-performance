#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex/affine"
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 clean pipeline receipt' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
"$HOME/buster-fast-bench/exclusive.sh" ./build/compiler test-tier1-pipeline --cross-check
