#!/bin/bash
# build-tree.sh NAME REVISION [PATCH...]: the tree NAME (cloned from ../src, buster main's clone, REVISION fetched from
# GitHub when the clone lacks it): REVISION with each PATCH applied in turn, then one Release build, in one hold of the
# lock. NAME/build/compiler; build-NAME.log. HOST_ARCH (default native) is the build's BUSTER_HOST_ARCH: x86-64 builds
# the baseline, whose readers take the scalar paths. DEBUG_INFO (default unset) is BUSTER_DEBUG_INFO.
set -u
cd "$(dirname "$0")"
name=$1
revision=$2
shift 2
[ -d "$name" ] || git clone -q ../src "$name" || exit 1
git -C "$name" cat-file -e "$revision^{commit}" 2> /dev/null || git -C "$name" fetch -q https://github.com/buster14a/buster "$revision" || exit 1
git -C "$name" checkout -q --detach "$revision" && git -C "$name" reset -q --hard || exit 1
for patch in "$@"; do
    git -C "$name" apply "$PWD/$patch" || exit 1
done
git -C "$name" diff --stat | tail -1
./lock.sh bash -c "cd $name && BUSTER_HOST_ARCH=${HOST_ARCH:-native} ${DEBUG_INFO:+BUSTER_DEBUG_INFO=$DEBUG_INFO} ./build.sh --config Release" > "build-$name.log" 2>&1
echo "build exit $?" >> "build-$name.log"
sha256sum "$name/build/compiler" >> "build-$name.log" 2>&1
tail -2 "build-$name.log"
