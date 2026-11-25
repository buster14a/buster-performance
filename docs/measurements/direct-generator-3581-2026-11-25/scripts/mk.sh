#!/bin/bash
# mk.sh NAME [SRCDIR]: the harness around SRCDIR's c_direct.c, znver5 (shipped to the 9700X unless NOSHIP=1) and native.
set -euo pipefail
name=$1; src=${2:-/home/user/buster}
cd "$src"
PATH="$(bash /home/user/buster/tools/ci/session-toolchain.sh stage):$PATH"
flags=(-Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static ${EXTRA_FLAGS:-})
clang -march=znver5 "${flags[@]}" src/buster/compiler/c_direct.c /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name" &
clang -march=native "${flags[@]}" src/buster/compiler/c_direct.c /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name.native" &
wait
/home/user/dp/run.sh "$name" -o /home/user/dp/out/$name.o > /home/user/dp/out/$name.log 2>&1 || echo "COMPILE FAILED"
h=$(sha256sum < /home/user/dp/out/$name.o | cut -c1-16)
echo "object $h"
if [ "${NOSHIP:-0}" != 1 ]; then
zstd -q -3 -c "/home/user/dp/bin/direct-$name" | timeout 180 tailscale ssh david@benchpress "mkdir -p ~/buster-fast-bench/3581-claude-hape45/bin && zstd -d > ~/buster-fast-bench/3581-claude-hape45/bin/direct-$name && chmod +x ~/buster-fast-bench/3581-claude-hape45/bin/direct-$name"
echo "shipped direct-$name"
fi
