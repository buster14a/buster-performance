#!/bin/bash
# mk.sh NAME [SRCDIR]: the harness around SRCDIR's c_direct.c (the checkout's by default), built for znver5 with CI's
# clang as bin/direct-NAME and for this host as bin/direct-NAME.native; checks sqlite3.c's object; ships the first.
set -euo pipefail
name=$1; src=${2:-/home/user/buster}
cd /home/user/buster
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
flags=(-Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static)
inc=(-I"$src/src")
clang -march=znver5 "${inc[@]}" "${flags[@]}" "$src/src/buster/compiler/c_direct.c" /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name" 2>&1 | grep -v no-pie || true &
clang -march=native "${inc[@]}" "${flags[@]}" "$src/src/buster/compiler/c_direct.c" /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name.native" 2>&1 | grep -v no-pie || true &
wait
o=/tmp/claude-0/-home-user/0fb9941e-4c77-5906-8b22-758d7876e82f/scratchpad/$name.o
/home/user/dp/run.sh "$name" -o "$o" > /dev/null 2>&1 || echo "COMPILE FAILED"
echo "object $(sha256sum < "$o" | cut -c1-16)"
if [ "${SHIP:-1}" = 1 ]; then
zstd -q -3 -c "/home/user/dp/bin/direct-$name" | timeout 300 tailscale ssh david@benchpress "zstd -d > ~/buster-fast-bench/3584-direct-s6acj8/bin/direct-$name && chmod +x ~/buster-fast-bench/3584-direct-s6acj8/bin/direct-$name && ~/buster-fast-bench/3584-direct-s6acj8/bin/direct-$name --repeat 0 > /dev/null 2>&1; echo shipped \$?"
fi
