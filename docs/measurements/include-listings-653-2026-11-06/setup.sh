#!/bin/bash
# #653 setup on the 9700X: base and pr trees, both built for znver5 under the lock, and zlib's sources.
set -euo pipefail
D=~/buster-fast-bench/653-claude
cd "$D"
LOCK=(env EXCLUSIVE_OWNER=claude-653 "EXCLUSIVE_TITLE=Solve 653 (include search listings)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/653 ~/buster-fast-bench/exclusive.sh)
if [ ! -d base ]; then
    git clone -q https://github.com/buster14a/buster base
    git -C base checkout -q ec5f0f6b
fi
rm -rf pr
git clone -q base pr
git -C pr checkout -q ec5f0f6b
git -C pr apply "$D/653.patch"
if [ ! -d zlib-1.3.1 ]; then
    curl -sSL -o zlib.tar.gz https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz
    echo "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23  zlib.tar.gz" | sha256sum -c
    tar xzf zlib.tar.gz
fi
for t in base pr; do
    if [ "$t" = pr ] || [ ! -x base/build/compiler ]; then
        "${LOCK[@]}" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$D/$t/build.sh" --jobs 8 > "$D/$t-build.log" 2>&1
        sha256sum "$D/$t/build/compiler"
    fi
done
echo setup-done
