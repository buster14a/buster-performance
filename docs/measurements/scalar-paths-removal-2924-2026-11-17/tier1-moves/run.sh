#!/bin/bash
# run.sh: build the moves gate with the 9700X's toolchain clang and run it on CPU 2, one locked run.
set -u
cd "$(dirname "$0")"
CC=$HOME/.cache/buster/benchpress-clang/bin/clang
test -x $CC || CC=$(ls -d $HOME/.cache/buster/benchpress-clang/*/bin/clang 2>/dev/null | head -1)
CF="-O3 -march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing"
$CC --version | head -1
$CC $CF -Iold/src -Iold/src/buster/compiler -DSIDE=old_side -c side.c -o old.o && $CC $CF -Inew/src -Inew/src/buster/compiler -DSIDE=new_side -c side.c -o new.o && $CC $CF -c gate.c -o gate.o && $CC gate.o old.o new.o -o gate || exit 1
sha256sum gate
taskset -c 2 ./gate replay moves-dump.bin
taskset -c 2 ./gate synth
