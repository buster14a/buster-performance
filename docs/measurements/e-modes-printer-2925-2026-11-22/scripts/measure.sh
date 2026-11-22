#!/bin/bash
# #2925's A/B on the 9700X: main d5fbf14e (base) against the branch 570138a0 (head), Release builds, each run under the
# lock alone (ab --lock, through lockps.sh), pinned to CPU 2, in a Williams order over 6 rounds; then one -E -C run on
# the head for information. The inputs are the head tree's main.c and src.
set -u
D=~/buster-fast-bench/1380-claude-2925
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
cd $D/head
echo "== ab start $(date -u +%FT%TZ)"
./build/compiler ab --rounds 6 --cpu 2 --lock $D/lockps.sh ../base ../head \
    -- benchmark-preprocessor --clang -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c \
    -- benchmark-preprocessor --markers -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c \
    -- benchmark-preprocessor --tables src > $D/ab.log 2>&1
echo "ab exit $? $(date -u +%FT%TZ)"
echo "== -C start $(date -u +%FT%TZ)"
$D/lockps.sh taskset -c 2 ./build/compiler benchmark-preprocessor -E -C -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c > $D/head-C.log 2>&1
echo "-C exit $? $(date -u +%FT%TZ)"
echo "measure done"
