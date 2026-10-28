#!/usr/bin/env bash
set -euo pipefail
stage=/home/david/buster-fast-bench/unclaimed-perf-20261028/issue-529-b8ee-clang2314
toolroot=/home/david/buster-fast-bench/unclaimed-perf-20261028/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
baseline=/home/david/buster-fast-bench/unclaimed-perf-20261028/integrated-e7-672-clang2314/compiler-native
export PATH="$toolroot/bin:$PATH"
cd "$stage/head"
printf '%s  %s\n' 06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e "$baseline" | sha256sum -c - > "$stage/baseline-before.log"
sha256sum -c ../source-SHA256SUMS > "$stage/source-before.log"
clang --version > "$stage/clang-version.txt"
export BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=1 BUSTER_CAPTURE_OBJECTS="$stage/objects"
bash -x "$stage/method/build-capture.sh" > "$stage/build-trace.log" 2>&1
sha256sum build/compiler > "$stage/compiler-SHA256.txt"
readelf -p .comment build/compiler > "$stage/compiler-comment.txt"
readelf -Wl build/compiler > "$stage/compiler-program-headers.txt"
sha256sum -c ../source-SHA256SUMS > "$stage/source-after.log"
sha256sum "$stage"/objects/*.o > "$stage/object-SHA256SUMS"
printf '%s\n' "b8ee29009260785aadc2659472daac30d44c081a" > "$stage/SOURCE_COMMIT"
printf '%s  %s\n' 06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e "$baseline" | sha256sum -c - > "$stage/baseline-after.log"
