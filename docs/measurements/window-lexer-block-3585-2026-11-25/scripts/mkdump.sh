#!/bin/bash
# mkdump.sh NAME SRCDIR: lexdump-NAME for this host
set -euo pipefail
export PATH="$(bash /home/user/buster/tools/ci/session-toolchain.sh stage):$PATH"
clang -march=native -I"$2/src" -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O2 -g -w /home/user/dp/micro/lexdump.c -o /home/user/dp/bin/lexdump-$1
