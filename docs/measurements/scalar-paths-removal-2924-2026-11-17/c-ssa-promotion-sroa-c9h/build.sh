#!/bin/bash
# build.sh NAME REV [PATCH...]: a Release compiler of REV plus the patches, as ~/buster-fast-bench/2924-c9h/compiler-NAME.
set -uo pipefail
D=~/buster-fast-bench/2924-c9h
name=$1; rev=$2; shift 2
export EXCLUSIVE_OWNER=claude-2924-c9h EXCLUSIVE_TITLE="buster #2924: IR promotion and SROA twins (C9h)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
cd $D/src || exit 1
git fetch -q origin "$rev" 2>/dev/null
git checkout -q --detach "$rev" && git reset -q --hard && git clean -qfd -e build || exit 1
for p in "$@"; do git apply "$p" || { echo "patch $p failed"; exit 1; }; done
~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./build.sh --config Release > $D/build-$name.log 2>&1 || { echo "build failed"; tail -5 $D/build-$name.log; exit 1; }
cp build/compiler $D/compiler-$name && sha256sum $D/compiler-$name
