#!/bin/bash
# job-xcensus-own.sh: the X census on the compiler's own source (the census's tree's main.c, with the toolchain's
# clang's predefines), on the 9700X: its lines aggregated to unique rows. One hold of the lock. No timing is read.
cd "$(dirname "$0")"
bench=$PWD
out=$bench/results/xc1
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
cd "$bench/trees/xc1" || exit 1
mkdir -p build
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
"$bench/lock.sh" bash -c "BUSTER_CENSUS_X=1 taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-contexts -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c 2> $out/census-own.err | python3 $bench/aggregate-x.py $out/census-own.tsv 2> $out/census-own.log; echo status \${PIPESTATUS[0]} >> $out/census-own.log"
echo job finished
