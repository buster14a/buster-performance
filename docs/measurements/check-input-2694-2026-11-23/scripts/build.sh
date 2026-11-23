#!/bin/bash
# build.sh TREE [CONFIG]: a znver5 build of TREE without debug information (DEBUG=1 for -g), one lock hold, with the
# 9700X job's staged clang first on PATH for trees whose build.sh predates the staged toolchain.
W=~/buster-fast-bench/2694-claude
cd $W/$1 || exit 2
T=$(ls -d ~/.cache/buster/benchpress-clang/*/bin | head -1)
B=$(ls -d ~/.cache/buster/build-tools/*/bin 2>/dev/null | head -1)
cfg=()
grep -q -- "--config" build.sh && cfg=(--config ${2:-Release})
env EXCLUSIVE_OWNER=claude-2694 "EXCLUSIVE_TITLE=#2694: check-input regrowth" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2694 \
  ~/buster-fast-bench/exclusive.sh env PATH=$T:${B:+$B:}$PATH BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=${DEBUG:-0} ./build.sh "${cfg[@]}" > $W/build-$1.log 2>&1
echo "status=$?" >> $W/build-$1.log
