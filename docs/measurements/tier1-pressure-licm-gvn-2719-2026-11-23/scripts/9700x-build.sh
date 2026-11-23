#!/bin/bash
# #2719: Release build of the head tree on the 9700X, under the lock.
D=~/buster-fast-bench/2719-claude
cd $D/head
export EXCLUSIVE_OWNER=claude-2719 EXCLUSIVE_TITLE="Tier 1 pressure-aware LICM and GVN (#2719)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2719
~/buster-fast-bench/exclusive.sh ./build.sh --config Release
echo "build rc=$?"
sha256sum build/compiler
