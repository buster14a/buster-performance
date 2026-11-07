#!/bin/bash
# Builds main3/ (git archive of buster 25a3fdb1d76ed4f440e8b4e99e10722a0f1304a7) as the 9700X job builds it
# (BUSTER_DEBUG_INFO=0, the native host), in a lock hold of its own; logs/build-main3.txt.
D=~/buster-fast-bench/447-claude
export EXCLUSIVE_OWNER=claude-447 EXCLUSIVE_TITLE="#447 residual gap: which units the driver reads apart" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/447
log="$D/logs/build-main3.txt"
cd "$D/main3" || exit 1
{ date -Is; echo 25a3fdb1d76ed4f440e8b4e99e10722a0f1304a7; clang --version | head -1; } > "$log"
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh >> "$log" 2>&1
echo "exit=$? $(date -Is)" >> "$log"
sha256sum build/compiler >> "$log"
