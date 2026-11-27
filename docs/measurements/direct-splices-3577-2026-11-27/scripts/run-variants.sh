#!/bin/bash
# run-variants.sh V...: builds each lex-V.c in work/ (one hold per build), then measures base and each (one hold per measurement)
cd ~/buster-fast-bench/3577-claude-splice
for v in "$@"; do
  cp lex-$v.c work/src/buster/compiler/c_direct_lex.c
  ./bp-build.sh work $v
done
./bp-measure.sh base "$@"
