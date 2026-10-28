#!/bin/sh
set -eu
cd source
date -u +%Y-%m-%dT%H:%M:%SZ > ../build-start.txt
clang --version > ../bootstrap-clang.txt
uname -a > ../kernel.txt
lscpu > ../cpu.txt
env BUSTER_DEBUG_INFO=1 BUSTER_HOST_ARCH=native ./build.sh > ../build.log 2>&1
cp build/compiler ../compiler-native
cd ..
cc -O2 -Wall -Wextra -Werror method/microarch.c -o microarch
ln -s /home/david/buster-fast-bench/microarch-20261027-exp/corpus corpus
sha256sum compiler-native microarch method/microarch.c method/sqlite-smoke.c corpus/sqlite/sqlite3.c corpus/gnu17-pinned-predefines.txt > build-inputs.sha256
date -u +%Y-%m-%dT%H:%M:%SZ > build-finish.txt
cat build-inputs.sha256
