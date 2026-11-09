#!/bin/bash
# #1840: run-b.sh's measure-tier1-rows step again, its --directory made first: by each family's head's compiler with
# --base main's, at -march=znver5, the lexer on five of main's sources, pinned to CPU 2, one hold each.
set -u
D=~/buster-fast-bench/1840-claude
cd $D
export EXCLUSIVE_OWNER=claude-1840 EXCLUSIVE_TITLE='Decode SIMD machine rows into IR operations (#1840)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
lex=""
for f in c_checker.c c_preprocessor.c tier1_select.c ir.c c_parser.c; do lex="$lex --lexer $D/base/src/buster/compiler/$f"; done
for n in a b c; do
  rm -rf $D/rows-tmp-$n; mkdir -p $D/rows-tmp-$n
  $X taskset -c 2 head-$n/build/compiler measure-tier1-rows --clang clang --base $D/base/build/compiler --src $D/head-$n/src $lex --march znver5 --directory $D/rows-tmp-$n > rows-$n.txt 2>&1
  echo "rows $n exit $?" >> log-c.txt
done
touch done-c
