#!/bin/bash
# The inventory's first heading (unity fixture ownership) on Develop's tree in `ci`, with check/build-regression built
# from the fixed harness (buster#2559): ownership.sh, under the lock.
set -euo pipefail
d=$HOME/buster-fast-bench/2559-claude
cd "$d/ci"
while IFS= read -r line; do export "$line"; done < "$d/ci.env"
while IFS= read -r line; do PATH="$line:$PATH"; done < "$d/ci.path"
export PATH BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
compiler=$(./build.sh print-output --config Develop)
"$d/check/build-regression" --ownership-only "$compiler"
