#!/bin/bash
# mkflags.sh NAME FLAGS...: the checkout's harness for znver5 with extra flags after the unit's own, shipped as
# bin/direct-NAME (an experiment's build, not the product's).
set -euo pipefail
name=$1; shift
cd /home/user/buster
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
flags=(-march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static)
clang "${flags[@]}" "$@" src/buster/compiler/c_direct.c /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name"
zstd -q -3 -c "/home/user/dp/bin/direct-$name" | timeout 120 tailscale ssh david@benchpress "zstd -d > ~/buster-fast-bench/2850-direct-tx5wvj/bin/direct-$name && chmod +x ~/buster-fast-bench/2850-direct-tx5wvj/bin/direct-$name"
echo "shipped direct-$name: $(size /home/user/dp/bin/direct-$name | tail -1 | awk '{print $1}') text"
