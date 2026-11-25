#!/bin/bash
# mkv.sh NAME [SRCDIR]: harness (direct-NAME) and microbenchmark (lexbench-NAME) of SRCDIR's c_direct.c for znver5
set -euo pipefail
name=$1; src=${2:-/home/user/buster}
export PATH="$(bash /home/user/buster/tools/ci/session-toolchain.sh stage):$PATH"
flags=(-I"$src/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static)
clang -march=znver5 -Werror "${flags[@]}" "$src/src/buster/compiler/c_direct.c" /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name" &
clang -march=znver5 -w "${flags[@]}" /home/user/dp/micro/lexbench.c -o "/home/user/dp/bin/lexbench-$name" &
wait
