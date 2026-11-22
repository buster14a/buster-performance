#!/bin/bash
# final-run.sh: the final code's Release build at both placement families (page shifts 0..3520 and line shifts 0..3120),
# then r6: main, main again, the branch as it was and the final code at the page-shift family, 10 rounds (#3261).
D=~/buster-fast-bench/3044-claude
cd $D
SDIR=shifts3 SHIFTS='0 704 1408 2112 2816 3520' ./shifts.sh fix
SDIR=shifts4 SHIFTS='0 16 32 48 2064 3120' ./shifts.sh fix
mkdir -p exe6 && for s in 0 704 1408 2112 2816 3520; do ln -f shifts/main/compiler-$s exe6/main-$s; ln -f shifts/main/compiler-$s exe6/mainx-$s; ln -f shifts/old/compiler-$s exe6/old-$s; ln -f shifts3/fix/compiler-$s exe6/fix-$s; done
test -x exe6/fix-0 && ./stage.sh r6 10 $(ls -d $PWD/exe6/*)
