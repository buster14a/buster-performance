#!/bin/bash
# mkpad.sh NAME SRCDIR PAD...: harnesses direct-NAME-pPAD with a PAD-byte function linked ahead of c_direct.c
set -euo pipefail
name=$1; src=$2; shift 2
export PATH="$(bash /home/user/buster/tools/ci/session-toolchain.sh stage):$PATH"
flags=(-I"$src/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static)
for pad in "$@"; do
    clang -march=znver5 "${flags[@]}" -DPAD=$pad /home/user/dp/pad.c "$src/src/buster/compiler/c_direct.c" /home/user/dp/direct_main.c -o "/home/user/dp/bin/direct-$name-p$pad" &
done
wait
