#!/bin/bash
# #1840 on the 9700X: main (cb608c1) against each family's head (A selects #1878, B width changes #1924, C permutes #1950,
# stacked on B), each built by build.sh (znver5, no debug information), one hold per build and per run:
#  1. measure-tier1-rows by each head's compiler with --base main's (the machine rows' unit, the byte-class scan and the
#     compiler's own lexer on five of its sources), at -march=znver5, pinned to CPU 2;
#  2. measure-tier1-programs' inputs (sqlite3.c and Lua's 33 sources) compiled by main's and each head's --tier1, objects
#     compared;
#  3. (run-a.sh's) the self-built compilers' stage timings, afterwards.
set -u
D=~/buster-fast-bench/1840-claude
cd $D
export EXCLUSIVE_OWNER=claude-1840 EXCLUSIVE_TITLE='Decode SIMD machine rows into IR operations (#1840)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
git -C repo fetch -q origin ir/1840-selects ir/1840-lanes ir/1840-permutes
for t in a:ef33ec8f2e576427d2c664d50990604065c961be b:aae6f8508ebd46208f4d0633216c5fbf54fc61b3 c:11dd0086b8152821b5745e755bbf0e5aae6eaa1b; do
  n=${t%%:*}; c=${t#*:}
  [ -d head-$n ] || git -C repo worktree add -q --detach ../head-$n $c
  git -C head-$n checkout -q --detach $c
  [ -x head-$n/build/compiler ] || $X sh -c "cd head-$n && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh" > build-head-$n.log 2>&1
  echo "build head-$n $c exit $?" >> log-b.txt
done
lex=""
for f in c_checker.c c_preprocessor.c tier1_select.c ir.c c_parser.c; do lex="$lex --lexer $D/base/src/buster/compiler/$f"; done
for n in a b c; do
  $X taskset -c 2 head-$n/build/compiler measure-tier1-rows --clang clang --base $D/base/build/compiler --src $D/head-$n/src $lex --march znver5 --directory $D/rows-tmp-$n > rows-$n.txt 2>&1
  echo "rows $n exit $?" >> log-b.txt
done
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p programs inputs
[ -d inputs/lua-5.4.8 ] || tar -xzf ~/buster-fast-bench/868-claude/inputs/lua-5.4.8.tar.gz -C inputs
for t in base head-a head-b head-c; do
  $X sh -c "$t/build/compiler -c --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -o programs/sqlite-$t.o $sqlite/sqlite3.c; for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do $t/build/compiler -c --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o programs/lua-\$s-$t.o inputs/lua-5.4.8/src/\$s.c; done" > programs/$t.log 2>&1
done
for t in head-a head-b head-c; do
  same=0; for f in programs/lua-*-base.o; do cmp -s $f ${f%-base.o}-$t.o && same=$((same+1)); done
  cmp -s programs/sqlite-base.o programs/sqlite-$t.o && s=identical || s=DIFFERENT
  echo "$t: sqlite object $s, lua objects identical $same of $(ls programs/lua-*-base.o | wc -l)" >> log-b.txt
done
touch done-b
