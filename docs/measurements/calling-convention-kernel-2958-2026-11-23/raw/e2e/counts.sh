#!/bin/bash
# PR 3364 counts only (rerun): counts (exp tree = 4bf5599a + count.patch) and A/B of real compiles, base (main 1b9821afe) vs head (4bf5599a).
set -e
D=~/buster-fast-bench/2958-claude
cd $D
L="EXCLUSIVE_OWNER=claude-2958 EXCLUSIVE_TITLE=PR3364-end-to-end EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3364"
X="env $L $HOME/buster-fast-bench/exclusive.sh"
mkdir -p inputs out
[ -d inputs/lua-5.4.8 ] || cp -r ~/buster-fast-bench/1360-claude/inputs/lua-5.4.8 inputs/
[ -d inputs/sqlite ] || cp -r ~/buster-fast-bench/1296-codex-20261105/corpus/sqlite inputs/
sha256sum inputs/sqlite/sqlite3.c inputs/lua-5.4.8/src/*.c > inputs.sha256
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin | head -1)/clang
$CLANG -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > out/predefines.h
git -C exp fetch -q $D/head 4bf5599ab:refs/tags/count-head 2>/dev/null || git -C exp fetch -q $D/head HEAD
git -C exp checkout -q -f $(git -C head rev-parse HEAD)
git -C exp apply $D/count.patch
grep -q abi_count_batches exp/src/buster/compiler/calling_convention.c
(cd exp && $X ./build.sh --config Release) > build-count.log 2>&1
cp exp/build/compiler compiler-count
SQ=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -Iinputs/sqlite inputs/sqlite/sqlite3.c)
LU=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
MC=(-march=native -Ihead/src -fwrapv -funsigned-char --predefines out/predefines.h head/src/buster/compiler/main.c)
for C in base head; do
cat > lua-$C.sh <<S
#!/bin/bash
# Lua 5.4.8's 34 files, each -c; extra arguments (--tier1) first.
for f in $D/inputs/lua-5.4.8/src/*.c; do $D/$C/build/compiler "\$@" -c ${LU[*]} -o $D/out/lua-$C.o "\$f" || exit 1; done
S
chmod +x lua-$C.sh
done
# (1) counts
$X bash -c "
for t in '' --tier1; do echo \"== sqlite3.c -c \$t\"; BUSTER_ABI_COUNT=1 ./compiler-count \$t -c ${SQ[*]} -o out/c.o 2>&1 | grep abi-count; done
echo '== lua -c (summed per file below)'; for f in inputs/lua-5.4.8/src/*.c; do BUSTER_ABI_COUNT=1 ./compiler-count -c ${LU[*]} -o out/c.o \$f 2>&1 | grep abi-count; done
echo '== main.c -c'; BUSTER_ABI_COUNT=1 ./compiler-count -c ${MC[*]} -o out/c.o 2>&1 | grep abi-count
echo '== main.c -fsyntax-only'; BUSTER_ABI_COUNT=1 ./compiler-count -fsyntax-only ${MC[*]} 2>&1 | grep abi-count || echo none
" > counts.log 2>&1
echo done > done-counts
