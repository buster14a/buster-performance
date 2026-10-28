#!/usr/bin/env bash
set -euo pipefail
campaign=/home/david/buster-fast-bench/unclaimed-perf-20261028
stage=$campaign/issue-529-b8ee-clang2314
toolroot=$campaign/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH="$toolroot/bin:$PATH" BUSTER_DEBUG_INFO=1 BUSTER_HOST_ARCH=native
case ${1-} in
    base)
        cd "$campaign/integrated-e7-672-clang2314/source"
        objects=$stage/stage2-base/objects
        manifest=$stage/stage2-base/object-SHA256SUMS
        source_manifest=$stage/method/base-source-SHA256SUMS
        ;;
    head)
        cd "$stage/head"
        objects=$stage/objects
        manifest=$stage/object-SHA256SUMS
        source_manifest=$stage/source-SHA256SUMS
        ;;
    *) exit 2 ;;
esac
role=$1
sha256sum -c "$manifest" > "$stage/hot-padding-$role-objects-before.log"
sha256sum -c "$source_manifest" > "$stage/hot-padding-$role-source-before.log"
bash -x "$stage/method/hot-padding-driver.sh" "$objects" "$stage/hot-$role" > "$stage/hot-padding-$role-trace.log" 2>&1
sha256sum -c "$manifest" > "$stage/hot-padding-$role-objects-after.log"
sha256sum -c "$source_manifest" > "$stage/hot-padding-$role-source-after.log"
