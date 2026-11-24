#!/bin/bash
set -eu
cd "$HOME/buster-fast-bench/1340-codex-20261124"
rev=$1
export EXCLUSIVE_OWNER=codex-1340 EXCLUSIVE_TITLE="Common warning facts #1340 ($rev build)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340
"$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 540 bash -eu -c '
  cd src
  export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
  if command -v cores >/dev/null 2>&1; then
    cores --all -- ./build.sh --config Release
  else
    ./build.sh --config Release
  fi
  cp build/compiler "../$1"
  sha256sum "../$1"
' _ "$rev"
