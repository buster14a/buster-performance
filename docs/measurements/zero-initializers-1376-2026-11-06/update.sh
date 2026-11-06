#!/bin/bash
# Move head and fill8 to the PR's new head, then rebuild them, each its own lock hold.
set -euo pipefail
cd ~/buster-fast-bench/1376-opencode
git -C repo fetch -q origin opencode/1376-zero-init
git -C head checkout -q --detach "$HEAD"
git -C fill8 checkout -q -- . && git -C fill8 checkout -q --detach "$HEAD"
sed -i 's/^#define BUSTER_CHECK_LOWER_FILL_UNROLLED 128u/#define BUSTER_CHECK_LOWER_FILL_UNROLLED 8u/' fill8/src/buster/compiler/c_check_program_initializers.c
git -C head log --oneline -1; git -C fill8 log --oneline -1; git -C fill8 diff --stat
for t in head fill8; do echo "== $t"; ./build.sh $t; done
echo done
