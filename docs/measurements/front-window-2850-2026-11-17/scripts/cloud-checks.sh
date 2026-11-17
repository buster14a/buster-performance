#!/bin/bash
# The commit's checks in the cloud container: a Release build of the tree, the whole test-checker, the shadow's runs in
# 12 modes on sqlite3.c, Lua, musl and the compiler's own source, the self-check, the self-parse and the call graph.
set -u
tree=/home/user/buster-window
out=/home/user/keep/window/final
mkdir -p "$out"
cd "$tree" || exit 1
git rev-parse HEAD > "$out/revision.txt"
git status --short >> "$out/revision.txt"
./build.sh --config Release > "$out/build.log" 2>&1
echo "build status $?" >> "$out/progress.txt"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
cp build/compiler /home/user/keep/window/compiler-final
TREE=$tree /home/user/keep/checker.sh "$out/test-checker" /home/user/keep/window/compiler-final
echo "checker done" >> "$out/progress.txt"
TREE=$tree /home/user/keep/shadow-limited.sh "$out/shadow" /home/user/keep/window/compiler-final "sqlite lua musl main" 2 \
    "--passes 0 --front-window --list 20" \
    "--passes 0 --front-window --front-tests --list 20" \
    "--passes 0 --front-window --front-own-tests -Wall -Wextra --list 20" \
    "--verify --passes 1 --front-window" \
    "-g --passes 0 --front-window" \
    "--passes 0 --front-window --front-warm" \
    "--passes 0 --front-window --front-flat" \
    "--passes 0 --front-facts --list 20" \
    "--passes 1 --facts --facts-operators" \
    "--passes 1" \
    "--passes 1 --front-sweeps" \
    "--passes 1 --front-flat"
echo "shadow done" >> "$out/progress.txt"
./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > "$out/self-check.txt" 2>&1
echo "self-check status $?" >> "$out/progress.txt"
./build/compiler parse -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c > "$out/self-parse.txt" 2>&1
echo "self-parse status $?" >> "$out/progress.txt"
./build/compiler test-call-graph > "$out/test-call-graph.txt" 2>&1
echo "test-call-graph status $?" >> "$out/progress.txt"
./build.sh check-call-graph --config Release > "$out/check-call-graph.txt" 2>&1
echo "check-call-graph status $?" >> "$out/progress.txt"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
echo "all done" >> "$out/progress.txt"
