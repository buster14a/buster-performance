#!/bin/bash
# final-verify.sh: the squashed commit on the newest main, in the worktree: a native Release build, test-checker's
# part 5, the self-check, the ownership check and the shadow with the rows on the compiler's own source.
out=/home/user/keep/xrows/final-verify
rm -rf "$out"; mkdir -p "$out"
cd /home/user/buster-x1 || exit 1
git rev-parse HEAD > "$out/revision.txt"; git status --short >> "$out/revision.txt"
BUSTER_HOST_ARCH=native ./build.sh --config Release > "$out/build.log" 2>&1
echo "build exit $?" >> "$out/progress.txt"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
./build/compiler test-checker --seed 133 --part 5/8 > "$out/part5.out" 2>&1
echo "part5 exit $?; $(grep 'test-checker:.*checks' "$out/part5.out" | tail -1)" >> "$out/progress.txt"
./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > "$out/self-check.txt" 2>&1
echo "self-check exit $?" >> "$out/progress.txt"
cc -std=c17 -O2 -o "$out/br" tools/ci/build_regression.c && "$out/br" --ownership-only "$PWD/build/compiler" > "$out/ownership.txt" 2>&1
echo "ownership exit $?" >> "$out/progress.txt"
./build/compiler measure-node-machine --shadow --passes 0 --window-rows --list 20 -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c > "$out/shadow-main.out" 2> "$out/shadow-main.err"
echo "shadow main exit $?; $(grep -h 'window rows expressions' "$out/shadow-main.out" "$out/shadow-main.err" | cut -c1-200)" >> "$out/progress.txt"
/home/user/buster/build/dco audit --base origin/main --head HEAD > "$out/dco.txt" 2>&1
echo "dco exit $?" >> "$out/progress.txt"
echo "all done" >> "$out/progress.txt"
