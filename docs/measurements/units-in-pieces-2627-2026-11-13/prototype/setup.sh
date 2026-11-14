#!/bin/bash
# #2627 prototype on the 9700X: a copy of 2626-claude/base (a11e44ac) built in Develop (znver5, CI's toolchain), its
# checker unit's dependency list, the unit's macros, piece_rename, and the pieces' Ninja build, built once. Each build
# its own hold of the lock.
set -eu
d=$HOME/buster-fast-bench/2627-claude
export EXCLUSIVE_OWNER=claude-2627 EXCLUSIVE_TITLE="#2627: the checker's unit in pieces (prototype)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2627
L="$HOME/buster-fast-bench/exclusive.sh timeout 1200"
. $HOME/buster-fast-bench/2626-claude/scripts/env.sh
export BUSTER_HOST_ARCH=znver5
if [ ! -d "$d/base" ]; then
    mkdir -p "$d/base"
    (cd "$HOME/buster-fast-bench/2626-claude/base" && tar -c --exclude=./build .) | tar -x -C "$d/base"
fi
cd "$d/base"
git log --oneline -1 2>/dev/null || true
$L ./build.sh > "$d/develop-build.log" 2>&1
tail -2 "$d/develop-build.log"
tree=$(dirname "$(dirname "$(./build.sh print-output)")")
echo "tree $tree"
ninja -C "$tree" -f build-Develop.ninja -t deps CMakeFiles/buster_main_unit_checker.dir/Develop/src/buster/compiler/main_unit_checker.c.o | tail -n +2 | sed 's/^ *//' | grep -v '^$' > "$d/files.txt"
wc -l < "$d/files.txt"
cc=$(grep '^CMAKE_C_COMPILER:' "$tree/CMakeCache.txt" | cut -d= -f2); llvm=$(dirname "$(dirname "$cc")")
libs=$(ninja -C "$tree" -f build-Develop.ninja -t commands codegen-tools/presplit | grep -- "-o $tree/codegen-tools/presplit " | sed 's/.*split_bitcode.o //')
cd "$d/proto"
"$cc" -O2 -Wall -Wextra -Werror -I"$llvm/include" -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -c piece_rename.c -o piece_rename.o
eval "${cc}++ -o piece_rename piece_rename.o $libs"
march=$(ninja -C "$tree" -f build-Develop.ninja -t commands Develop/develop/main_unit_checker/part0.o | tail -1 | grep -o -- '-march=[^ ]*')
mkdir -p "$d/n"
ACTION="-dM -E" ROOT="$d/base" CLANG="$cc" MARCH="$march" ./piece-cc.sh "$d/base/src" "$d/n/macros.h"
./gen.sh "$d/n" "$tree" "$d/files.txt" 8 6
$L ninja -C "$d/n" -j 8 > "$d/n/first.log" 2>&1
tail -1 "$d/n/first.log" | cut -c1-60
ls -la "$d/n/compiler"
