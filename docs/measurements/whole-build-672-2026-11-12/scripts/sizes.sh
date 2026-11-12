#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# sizes.sh: the outputs' sizes, after the runs that wrote them: each object's and executable's bytes and sections, and
# for the many-unit outputs each directory's bytes and its objects' sections summed. No timed run; it reads files.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/sizes
mkdir -p "$out"
sections()
{
    size -A "$@" 2> /dev/null | awk '$2 ~ /^[0-9]+$/ && $1 != "Total" { s[$1] += $2 } END { for (n in s) if (s[n] > 0) print n "\t" s[n] }' | sort
}
{
    for f in $t/o/b-c.o $t/o/b-cg.o $t/o/tcc-c.o $t/o/tcc-cg.o $t/o/tcc-cgdwarf.o $t/o/clang-c.o $t/o/clang-cg.o $t/o/gcc-c.o $t/o/gcc-cg.o \
             $t/x/shell.o $t/x/shell-g.o $t/x/sq.o $t/x/sq-g.o $t/x/k-shell.o $t/x/k-shell-g.o $t/x/k-sq.o $t/x/k-sq-g.o \
             $t/x/s-dyn $t/x/s-dyn-g $t/x/s-static $t/x/s-static-g $t/x/l-dyn $t/x/l-dyn-g $t/x/l-static $t/x/l-static-g $t/x/tcc-dyn $t/x/tcc-dyn-g \
             $t/xk/clang-dyn $t/xk/clang-dyn-g $t/xk/clang-lld-dyn $t/xk/clang-lld-dyn-g \
             $t/x/lf-dyn-b $t/x/lf-dyn-bg $t/x/lf-static-b $t/x/lf-static-bg $t/x/lld-dyn-b $t/x/lld-dyn-bg $t/x/lld-static-b $t/x/lld-static-bg \
             $t/x/mold-dyn-b $t/x/mold-dyn-bg $t/x/bfd-dyn-b $t/x/bfd-dyn-bg $t/x/lf-dyn-k $t/x/lf-dyn-kg $t/x/lld-dyn-k $t/x/lld-dyn-kg \
             $t/f/hello.o $t/f/hello-g.o $t/f/hello-dyn $t/f/hello-dyn-g $t/f/hello-static $t/f/hello-static-g \
             $t/ml/hello-lf $t/mlg/hello-lf $t/ml/hello-lld $t/mlg/hello-lld $t/ml/hello-mold $t/mlg/hello-mold $t/ml/hello-bfd $t/mlg/hello-bfd $t/ml/libc.a $t/mlg/libc.a \
             $t/y/o1/program $t/y/o1g/program; do
        if [[ -f $f ]]; then
            echo "== ${f#$t/} $(stat -c %s "$f") bytes"
            sections "$f"
        fi
    done
} > "$out/files.txt"
{
    for d in $t/m/c $t/m/cg $t/m/tc $t/m/tcg $t/m/tcc $t/m/tccg $t/m/tccd $t/m/kc $t/m/kcg $t/ml/a $t/mlg/a $t/ml/b $t/mlg/b $t/y/c1 $t/y/c1g; do
        if [[ -d $d ]]; then
            echo "== ${d#$t/} $(ls "$d" | grep -c '\.o$') objects $(cat "$d"/*.o | wc -c) bytes"
            (cd "$d" && sections *.o)
        fi
    done
} > "$out/directories.txt"
date -u +%FT%TZ > "$out/.done"
