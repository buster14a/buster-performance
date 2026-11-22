#!/usr/bin/env bash
# build-one.sh TREE NAME: one Release build of TREE (znver5, no -g) under the lock, the published executable copied to bin/NAME.
set -euo pipefail
. "$HOME/buster-fast-bench/3022-claude/env.sh"
cd "$W"
tree=$1; name=$2
echo "build $tree $name start $(date -u -Iseconds) head $(git -C "$tree" rev-parse HEAD)"
(cd "$tree" && "$LOCK" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release)
cp "$tree/build/compiler" "bin/$name"
sha256sum "bin/$name"
echo "build $tree $name end $(date -u -Iseconds)"
