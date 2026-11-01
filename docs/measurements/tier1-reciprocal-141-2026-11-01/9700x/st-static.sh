#!/usr/bin/env bash
# st-static.sh HEAD: the instructions of speedtest1's own functions (the functions clang -O0's objects of sqlite3.c and
# speedtest1.c define) in each of corpora.sh's speedtest1 builds, padding left out (static.awk), in one hold of the
# shared lock; tcc's executables have no symbol table, so none for it.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
st=$PWD/corpora-$1/st
"$lock" bash -c "cd $st && (nm --defined-only clang0-sqlite3.o; nm --defined-only clang0-speedtest1.o) | awk '\$2 ~ /^[Tt]\$/ { print \$3 }' | LC_ALL=C sort -u > functions.txt && for c in t0 t1 t1s clang0 clang2; do echo \"\$c \$(objdump -d --no-show-raw-insn st-\$c | awk -v list=functions.txt -f $PWD/static.awk)\"; done > static.txt"
