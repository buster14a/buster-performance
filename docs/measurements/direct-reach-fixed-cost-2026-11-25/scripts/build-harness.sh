#!/bin/bash
# build-harness.sh NAME PATCH...: resident.c around main + the patches' c_direct.c, built for znver5 with the tree's
# toolchain as bin/resident-NAME; the tree is left at main.
set -e
here=~/buster-fast-bench/direct-designs-np4nn5
cd $here/main
name=$1; shift
git checkout -q -- .
for p in "$@"; do git apply ../patches/$p; done
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
clang -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static src/buster/compiler/c_direct.c ../resident.c -o ../bin/resident-$name
git checkout -q -- .
echo "built resident-$name"
