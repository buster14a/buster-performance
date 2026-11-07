#!/bin/sh
# Build the baseline, then export sqlite3.c's qualified CFGs with the SEMI-NCA build; each run takes the lock itself.
cd ~/buster-fast-bench/1352-claude || exit 1
corpus=~/buster-fast-bench/corpus-391e729af658
(cd ../1352-claude-base && BUSTER_HOST_ARCH=znver5 ../1352-claude/run.sh ../1352-claude/base-build.log ./build.sh)
rm -f sqlite.cfg
unset CPATH C_INCLUDE_PATH
./run.sh export.log ./build/compiler test-ir-source --dominators-cfg sqlite.cfg --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
echo done > export.done
