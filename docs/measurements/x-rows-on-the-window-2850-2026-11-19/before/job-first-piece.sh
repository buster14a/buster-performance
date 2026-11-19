#!/bin/bash
# job-first-piece.sh: the X census's lines (xc2's build, census-x2.patch on main b84780116) an expression at a time
# (first-piece.py) on the three corpora and the compiler's own source, on the 9700X. One hold of the lock a run. No
# timing is read.
cd "$(dirname "$0")"
bench=$PWD
out=$bench/results/xc2
. ./corpora.sh
for c in sqlite3 lua musl; do
    case $c in
        sqlite3) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
        musl) arguments=$musl_arguments ;;
    esac
    ./lock.sh bash -c "BUSTER_CENSUS_X=1 taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments 2> /dev/null | python3 $bench/first-piece.py > $out/first-piece-$c.txt 2>&1"
done
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
cd "$bench/trees/xc2" || exit 1
mkdir -p build
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
"$bench/lock.sh" bash -c "BUSTER_CENSUS_X=1 taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-contexts -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c 2> /dev/null | python3 $bench/first-piece.py > $out/first-piece-own.txt 2>&1"
echo job finished
