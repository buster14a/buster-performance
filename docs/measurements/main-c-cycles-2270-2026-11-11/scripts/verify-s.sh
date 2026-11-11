#!/usr/bin/env bash
set -u
. "$HOME/buster-fast-bench/2270-claude/env.sh"
cd $W; mkdir -p out
src=$W/head/src
args=(-c -march=native -I"$src" -fwrapv -funsigned-char "$src/buster/compiler/main.c")
$L bash -c "cd $W; for t in base head; do ./\$t/build/compiler ${args[*]} -o out/\$t.o; for s in 0 1 2 5; do BUSTER_ARENA_SHIFT=\$s ./\$t-s/build/compiler ${args[*]} -o out/\$t-s\$s.o; done; done"
for f in out/*.o; do cmp out/base.o $f && echo "$f == base.o"; done
echo done
