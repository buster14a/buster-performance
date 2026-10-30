#!/bin/bash
cd $HOME/buster
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
export TMPDIR=$HOME/.cache/claude-134/tmp
S=$HOME/scratch
corpus=$HOME/.cache/claude-frozen-corpus
musl=$HOME/.cache/claude-131/corpus/libc/musl
generated=$HOME/.cache/claude-131/corpus/musl-generated
lua=$HOME/buster-lab/inputs/lua-5.4.8/src
renice -n 19 -p $$ > /dev/null; ionice -c 3 -p $$
export CORES_TITLE="solve 134 corpora" CORES_LINK="https://github.com/buster14a/buster/issues/134"
{ time cores -n 1 -- ./build/compiler test-ssa-source --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"; } > $S/sqlite.log 2>&1
{ time cores -n 1 -- ./build/compiler test-ssa-source --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os \
  -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$generated/obj/include" -I "$musl/include" \
  "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; } > $S/musl.log 2>&1
{ time cores -n 1 -- ./build/compiler test-ssa-source -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX $(ls $lua/*.c | grep -v '/lua\.c$' | grep -v '/luac\.c$'); } > $S/lua.log 2>&1
{ time cores -n 3 -- ./build/compiler test-ssa-source --generate 1000 --seed 7 --clang clang; } > $S/gen1000.log 2>&1
echo done > $S/corpora.done
