#!/bin/bash
set -euo pipefail
root=/home/david/buster-fast-bench/codex-449-450-451-20261026
chmod 755 "$root/limited-wild-native.sh"
cd "$root/head450-phase"
taskset -c 0,1,3,4,5,6 env BUSTER_DEBUG_INFO=0 OMP_NUM_THREADS=1 BUSTER_LINKER="$root/limited-wild-native.sh" ./build.sh
sha256sum build/compiler
