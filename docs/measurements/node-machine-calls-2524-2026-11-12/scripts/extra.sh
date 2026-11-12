#!/bin/bash
# extra.sh LABEL...: the shadow with --verify on c-testsuite's subset (tests/c-testsuite/subset.txt of the measured
# commit's tree, c-testsuite at 5c727565) and on the measured commit's own main.c (with this host's -march=native
# predefines), by each label's compiler, CPU 2, a hold of the lock a run. It compares and counts; it doesn't time.
set -u
cd "$(dirname "$0")"
test -d c-testsuite/tests || (git init -q --template= c-testsuite && git -C c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07 && git -C c-testsuite checkout -q FETCH_HEAD)
tree=$PWD/trees/head
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > results/predefines.h
files=$(sed -n "s|^\([0-9][0-9]*\)$|$PWD/c-testsuite/tests/single-exec/\1.c|p" "$tree/tests/c-testsuite/subset.txt" | tr '\n' ' ')
for label in "$@"; do
    out=$PWD/results/$label
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner >> '$out/verify-holds.txt'; taskset -c 2 '$out/compiler' measure-node-machine --shadow --verify --passes 0 --list 20 $files > '$out/verify-c-testsuite.txt' 2>&1; echo \"status \$?\" >> '$out/verify-c-testsuite.txt'"
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner >> '$out/verify-holds.txt'; cd '$tree' && taskset -c 2 '$out/compiler' measure-node-machine --shadow --verify --passes 0 --list 20 -march=native -Isrc -fwrapv -funsigned-char --predefines '$PWD/results/predefines.h' src/buster/compiler/main.c > '$out/verify-main.txt' 2>&1; echo \"status \$?\" >> '$out/verify-main.txt'"
done
date -u +%FT%TZ > results/.extra-done
