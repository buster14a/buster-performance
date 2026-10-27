#!/usr/bin/env bash
# Run outside the shared lock: each bounded experiment takes it separately.
set -euo pipefail
cd "$(dirname "$0")/.."
export EXCLUSIVE_OWNER=codex-601 EXCLUSIVE_TITLE='Buster 601 static bit-field comparison' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/601
~/buster-fast-bench/exclusive.sh bash evidence/measure.sh preflight
~/buster-fast-bench/exclusive.sh bash evidence/compare.sh
~/buster-fast-bench/exclusive.sh bash evidence/measure.sh stages
