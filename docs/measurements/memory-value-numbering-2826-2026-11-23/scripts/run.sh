#!/bin/bash
# #2826 baseline on main: run time of +memory and +memory,+gvn, compile time of +memory. Under exclusive.sh.
D=~/buster-fast-bench/2826-claude
I=~/buster-fast-bench/3309-claude
CLANGDIR=$(ls -d ~/.cache/buster/benchpress-clang/*/bin 2>/dev/null | head -1)
export PATH=$CLANGDIR:$PATH
unset CPATH C_INCLUDE_PATH
B=$D/$1/build/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
echo "tree $1 commit $(git -C $D/$1 rev-parse HEAD)"; clang --version | head -1
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
mkdir -p $D/tmp
if [ "$2" = programs ]; then
  cd $D/$1 && taskset -c 2 $B measure-tier1-programs --runs 11 --clang clang --sqlite "$sqlite" --speedtest $I/inputs --lua $I/inputs/lua-5.4.8/src --scripts $I/evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua --directory $D/tmp --variant --tier1-passes=+memory --variant --tier1-passes=+memory,+gvn
else
  source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
  cd $D/tmp && taskset -c 2 $B measure-compile --runs 11 --variant --tier1-passes=+memory -- -c --tier1 --lanes 1 "${source[@]}" $sqlite/sqlite3.c
fi
echo "rc=$?"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
