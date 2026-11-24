#!/bin/bash
# mk.sh NAME [SRCDIR]: the harness around SRCDIR's c_direct.c (the checkout's by default), built for znver5 with CI's
# clang as bin/direct-NAME, and for this host as bin/direct-NAME.native; ships the first to the 9700X.
set -euo pipefail
name=$1; src=${2:-/home/user/buster}
cd /home/user/buster
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
mkdir -p /home/user/dp/bin
flags=(-Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static)
inc=(); [ "$src" != /home/user/buster ] && inc=(-I"$src")
clang -march=znver5 "${inc[@]}" "${flags[@]}" "$src/src/buster/compiler/c_direct.c" /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name" &
clang -march=native "${inc[@]}" "${flags[@]}" "$src/src/buster/compiler/c_direct.c" /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name.native" &
wait
zstd -q -3 -c "/home/user/dp/bin/direct-$name" | timeout 120 tailscale ssh david@benchpress "zstd -d > ~/buster-fast-bench/2850-direct-tx5wvj/bin/direct-$name && chmod +x ~/buster-fast-bench/2850-direct-tx5wvj/bin/direct-$name"
echo "built and shipped direct-$name"
