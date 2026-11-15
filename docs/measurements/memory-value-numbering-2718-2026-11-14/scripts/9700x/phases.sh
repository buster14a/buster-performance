#!/bin/bash
# The memory pass's phases by TSC on the 9700X: a patched tree (phases.patch over COMMIT), sqlite3.c's functions through
# test-ir-source --passes, with the vector addresses and with the scalar ones.
D=~/buster-fast-bench/2718-claude
COMMIT=$1
export EXCLUSIVE_OWNER=claude-2718 EXCLUSIVE_TITLE="#2718 memory value numbering" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2718
cd $D
[ -d phases ] || git clone -q $D/buster phases
cd phases && git fetch -q https://github.com/buster14a/buster claude/loving-goodall-lj1n26 && git checkout -q -f $COMMIT && git apply $D/phases.patch && git log -1 --oneline > $D/results/phases-commit.txt
~/buster-fast-bench/exclusive.sh timeout -k 5 1500 ./build.sh --config Release > $D/results/phases-build.log 2>&1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
O="--predefines $C/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c"
unset CPATH C_INCLUDE_PATH
for variant in vector scalar-addresses vector-again; do
  E=""; [ $variant = scalar-addresses ] && E="BUSTER_MEM_SCALAR_ADDRESSES=1"
  ~/buster-fast-bench/exclusive.sh timeout -k 5 600 env $E taskset -c 2 ./build/compiler test-ir-source --passes $O > $D/results/phases-$variant.log 2>&1
done
echo done > $D/results/phases-done.txt
