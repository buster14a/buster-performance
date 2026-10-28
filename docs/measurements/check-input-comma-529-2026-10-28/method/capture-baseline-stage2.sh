#!/usr/bin/env bash
# One approved rebuild in the original cwd, preserving the immutable outside baseline.
set -euo pipefail
campaign=/home/david/buster-fast-bench/unclaimed-perf-20261028
stage=$campaign/issue-529-b8ee-clang2314
common=$campaign/integrated-e7-672-clang2314
control=$stage/stage2-base
toolroot=$campaign/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH="$toolroot/bin:$PATH"
test ! -e "$control"
mkdir "$control"
tar -cf "$control/previous-build.tar" -C "$common" source/build build.log stage-build.sh bootstrap-clang.txt build-inputs.sha256 official-tool.sha256 SOURCE_COMMIT frozen-header-files.sha256
printf '%s  %s\n' 06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e "$common/compiler-native" \
    06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e "$common/source/build/compiler" > "$control/expected-before.sha256"
sha256sum -c "$control/expected-before.sha256" > "$control/immutable-before.log"
cd "$common"
sha256sum -c frozen-header-files.sha256 > "$control/headers-before.log"
sha256sum -c official-tool.sha256 > "$control/tool-before.log"
cd source
sha256sum -c "$stage/method/base-source-SHA256SUMS" > "$control/source-before.log"
cmp build.sh "$stage/head/build.sh"
clang --version > "$control/clang-version.txt"
export BUSTER_DEBUG_INFO=1 BUSTER_HOST_ARCH=native BUSTER_CAPTURE_OBJECTS="$control/objects"
bash -x "$stage/method/build-capture.sh" > "$control/build-trace.log" 2>&1
sha256sum build/compiler > "$control/rebuilt-SHA256.txt"
cmp build/compiler "$common/compiler-native"
printf '%s  %s\n' 06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e build/compiler | sha256sum -c - > "$control/reproducible.log"
cp build/compiler "$control/compiler-native"
cp build/compile_commands.json "$control/compile_commands.json"
sha256sum -c "$stage/method/base-source-SHA256SUMS" > "$control/source-after.log"
cd "$common"
sha256sum -c frozen-header-files.sha256 > "$control/headers-after.log"
sha256sum -c official-tool.sha256 > "$control/tool-after.log"
sha256sum "$control"/objects/*.o > "$control/object-SHA256SUMS"
sha256sum -c "$control/expected-before.sha256" > "$control/immutable-after.log"
