#!/bin/bash
# head-check.sh: the pull request's head (the piece on the latest main): a native Release build, the node machine's
# part of test-checker, and the shadow with the tests on the window in its five modes on the four corpora.
set -u
tree=/home/user/buster
out=/home/user/keep/quiet-final/head
mkdir -p "$out"
cd "$tree" || exit 1
{ git rev-parse HEAD; git status --short; } > "$out/revision.txt"
echo "head check at $(git rev-parse --short HEAD) $(date -u +%H:%M)" >> "$out/progress.txt"
BUSTER_HOST_ARCH=native ./build.sh --config Release > "$out/build.log" 2>&1
echo "build status $?" >> "$out/progress.txt"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
cp build/compiler "$out/compiler"
"$out/compiler" test-checker --seed 133 --part 5/8 > "$out/part5.out" 2> "$out/part5.err"
echo "part5 status $?; $(tail -1 "$out/part5.out")" >> "$out/progress.txt"
TREE=$tree /home/user/keep/shadow-limited.sh "$out/shadow" "$out/compiler" "sqlite lua musl main" 2 \
    "--passes 0 --window-tests --list 20" \
    "--passes 0 --window-tests -Wall -Wextra --list 20" \
    "--passes 0 --window-tests --verify --list 20" \
    "--passes 0 --window-tests --verify -Wall -Wextra --list 20" \
    "-g --passes 0 --window-tests"
echo "shadow done: $(grep -c 'status 0' "$out/shadow/status.txt") of 20 runs with status 0" >> "$out/progress.txt"
./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > "$out/self-check.txt" 2>&1
echo "self-check status $?" >> "$out/progress.txt"
echo "all done $(date -u +%H:%M)" >> "$out/progress.txt"
