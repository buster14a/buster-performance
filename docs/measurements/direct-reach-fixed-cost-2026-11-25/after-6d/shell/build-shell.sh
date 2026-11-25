#!/bin/bash
# build-shell.sh: the variant tree at main 38483c5b, built as compiler-main38 and with a 1,024-frame statement stack as
# compiler-deep (shell.c's ceiling, #3592).
set -e
here=~/buster-fast-bench/direct-designs-np4nn5
cd $here/main
git checkout -q -- . && git clean -fdq
git fetch -q origin main
git checkout -q 38483c5ba
cp $here/step2/deep.patch $here/patches/deep.patch
cd $here
./build-variant.sh main38
./build-variant.sh deep deep.patch
tail -2 build-main38.log build-deep.log
