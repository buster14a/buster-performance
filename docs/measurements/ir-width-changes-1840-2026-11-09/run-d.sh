#!/bin/bash
# #1840: measure-tier1-rows again for family A (twice) and B (once, a control), as run-c.sh ran it, to see whether A's
# 0.5% slower lexer reproduces: its Tier 1 code of the lexer differs from main's only by each select's three records
# (vmovdqu64, a merge-masked vmovdqu8 and vmovdqa64) as one vpblendmb, of the same 2-cycle latency on Zen 5.
set -u
D=~/buster-fast-bench/1840-claude
cd $D
export EXCLUSIVE_OWNER=claude-1840 EXCLUSIVE_TITLE='Decode SIMD machine rows into IR operations (#1840)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
lex=""
for f in c_checker.c c_preprocessor.c tier1_select.c ir.c c_parser.c; do lex="$lex --lexer $D/base/src/buster/compiler/$f"; done
for r in a2 b2 a3; do
  n=${r%?}
  rm -rf $D/rows-tmp-$r; mkdir -p $D/rows-tmp-$r
  $X taskset -c 2 head-$n/build/compiler measure-tier1-rows --clang clang --base $D/base/build/compiler --src $D/head-$n/src $lex --march znver5 --directory $D/rows-tmp-$r > rows-$r.txt 2>&1
  echo "rows $r exit $?" >> log-d.txt
done
touch done-d
