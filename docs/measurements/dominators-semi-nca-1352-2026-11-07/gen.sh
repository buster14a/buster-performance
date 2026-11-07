#!/bin/sh
# Generate #1352's three single-function inputs for N alternatives into DIR: gotos-N.c, ifs-N.c, ternary-N.c.
dir=$1; N=$2
{ printf 'int g(int a) {'; i=0; while [ $i -lt $N ]; do printf 'if (a == %d) goto L%d;' $i $i; i=$((i+1)); done
  printf 'return 0;'; i=0; while [ $i -lt $N ]; do printf 'L%d: a += %d;' $i $i; i=$((i+1)); done; printf 'return a; }\n'; } > $dir/gotos-$N.c
{ printf 'int g(int a) {'; i=0; while [ $i -lt $N ]; do printf 'if (a > %d) { a += %d;' $i $i; i=$((i+1)); done
  i=0; while [ $i -lt $N ]; do printf '}'; i=$((i+1)); done; printf 'return a; }\n'; } > $dir/ifs-$N.c
{ printf 'int g(int a) { return '; i=0; while [ $i -lt $N ]; do printf 'a == %d ? %d : ' $i $((i*2)); i=$((i+1)); done; printf '0; }\n'; } > $dir/ternary-$N.c
