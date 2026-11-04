#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# The _Generic scaling check: N functions with one selection each, -fsyntax-only
# --time-stages, 3 runs per N, before #1049 and on main. Run from this directory
# inside a one-core grant, with ROOT the run root (README.md):
#   clang -O2 -o gen gen.c && ROOT=... cores -n 1 -- ./run.sh > scaling-HOST.txt
cd "$(dirname "$0")"; export LC_ALL=C; ROOT=${ROOT:?the run root}
CPU=${CORES_CPUS%%,*}
for b in pre1049-znver4 znver4; do
  for n in 250 500 1000 2000 4000; do
    ./gen $n > g$n.c
    best=""
    for r in 1 2 3; do
      taskset -c $CPU "$ROOT"/bin/compiler-$b -fsyntax-only --time-stages g$n.c 2> t.txt
      cp=$(awk -F'\t' '$1=="time-stage" && $2=="check-program"{print $3}' t.txt); tot=$(awk -F'\t' '$1=="time-stage" && $2=="total"{print $3}' t.txt)
      echo "$b $n $r $cp $tot"
    done
  done
done
