#!/usr/bin/env bash
# build-one.sh TREE CONFIG NAME [DEFINES]: one ./build.sh of TREE under the lock (Develop, or Release for znver5
# without -g), with BUSTER_BUILD_DEFINES=DEFINES, then the published executable copied to bin/NAME.
set -euo pipefail
. "$HOME/buster-fast-bench/3067-claude/env.sh"
cd "$W"
tree=$1; config=$2; name=$3; defines=${4:-}
echo "build $tree $config $name defines '$defines' start $(date -u -Iseconds) head $(git -C "$tree" rev-parse HEAD)"
if [ "$config" = Release ]; then
    (cd "$tree" && "$LOCK" env BUSTER_BUILD_DEFINES="$defines" BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release)
else
    (cd "$tree" && "$LOCK" env BUSTER_BUILD_DEFINES="$defines" ./build.sh)
fi
cp "$tree/build/compiler" "bin/$name"
sha256sum "bin/$name"
echo "build $tree $config $name end $(date -u -Iseconds)"
