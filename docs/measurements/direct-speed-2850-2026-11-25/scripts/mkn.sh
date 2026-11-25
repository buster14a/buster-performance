#!/bin/bash
# mkn.sh NAME: native + znver5 harness from the checkout, check the sqlite object's hash, ship znver5 to the 9700X.
set -euo pipefail
name=$1
cd /home/user/buster
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
flags=(-Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static)
clang -march=znver5 "${flags[@]}" src/buster/compiler/c_direct.c /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name" &
clang -march=native "${flags[@]}" src/buster/compiler/c_direct.c /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name.native" &
wait
/home/user/dp/run.sh "$name" -o /tmp/claude-0/-home-user/b10241dd-53c0-58fe-8fd0-76bf9692effd/scratchpad/$name.o > /dev/null 2>&1 || echo "COMPILE FAILED"
h=$(sha256sum < /tmp/claude-0/-home-user/b10241dd-53c0-58fe-8fd0-76bf9692effd/scratchpad/$name.o | cut -c1-16)
[ "$h" = ff67ee922b96b089 ] && echo "object identical ($h)" || echo "OBJECT DIFFERS: $h"
zstd -q -3 -c "/home/user/dp/bin/direct-$name" | timeout 120 tailscale ssh david@benchpress "zstd -d > ~/buster-fast-bench/2850-direct-r9uggb/bin/direct-$name && chmod +x ~/buster-fast-bench/2850-direct-r9uggb/bin/direct-$name"
echo "shipped direct-$name"
