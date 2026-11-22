#!/bin/bash
D=~/buster-fast-bench/3044-claude
cd $D
SDIR=shifts3 SHIFTS='0 16 32 48 2064 3120' ./shifts.sh fix
mkdir -p exe5 && for s in 0 16 32 48 2064 3120; do ln -f shifts2/main/compiler-$s exe5/main-$s; ln -f shifts2/main/compiler-$s exe5/mainx-$s; ln -f shifts3/fix/compiler-$s exe5/fix-$s; done
test -x exe5/fix-0 && ./stage.sh r5 8 $(ls -d $PWD/exe5/*)
