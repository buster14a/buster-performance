#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
. ./host.sh
for side in base head; do
    cmd=(./build.sh --config Release --jobs 8)
    if command -v cores >/dev/null; then cmd=(cores -n 8 -- "${cmd[@]}"); fi
    (cd "$side" && locked 540 "${cmd[@]}") > "raw/build-$side.log" 2>&1
    sha256sum "$side/build/compiler"
done
