#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=codex-1340 EXCLUSIVE_TITLE="Issue 1340 final source build" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340
"$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 540 bash -eu -c '
    cd src
    export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
    if command -v cores >/dev/null 2>&1; then cores --all -- ./build.sh --config Release; else ./build.sh --config Release; fi
    cp build/compiler ../head
    sha256sum ../head
'
