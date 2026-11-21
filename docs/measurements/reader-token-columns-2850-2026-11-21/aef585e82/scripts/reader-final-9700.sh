#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-reader-token-columns-final
shared=../2850-declaration-starts
export BUSTER_HOST_ARCH=znver5
for f in corpora.sh build-label.sh lock.sh; do cp "$shared/$f" .; done
ln -sfn "$shared/src" src
ln -sfn ../2850-codex-step2/inputs inputs
mkdir -p results
ln -sfn "$PWD/../2850-reader-token-columns/results/before" results/before
test "$(cat results/before/revision.txt)" = 4dd0f0b163d258dd7778cbb14676a7ac4bf3510a
./build-label.sh after aef585e82d341ef4269f642cda891501ee204f8f
bash cycles.sh
bash wall.sh
