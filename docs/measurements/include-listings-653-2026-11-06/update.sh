#!/bin/bash
# Re-applies the current patch to the pr tree and rebuilds it under the lock (after setup.sh).
set -euo pipefail
D=~/buster-fast-bench/653-claude
cd "$D"
while ! grep -q setup-done setup.log; do sleep 10; done
git -C pr checkout -q -- .
git -C pr clean -fdq src docs
git -C pr apply "$D/653.patch"
env EXCLUSIVE_OWNER=claude-653 "EXCLUSIVE_TITLE=Solve 653 (include search listings)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/653 \
    ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$D/pr/build.sh" --jobs 8 > "$D/pr-build.log" 2>&1
sha256sum base/build/compiler pr/build/compiler
echo update-done
