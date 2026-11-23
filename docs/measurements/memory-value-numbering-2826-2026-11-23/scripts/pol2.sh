#!/bin/bash
# #2826 policy experiments: measure-tier1-programs on the exp tree with four --tier1-memory-policy=N variants
# (each stands for --tier1-passes=+memory under BUSTER_MEMORY_POLICY=N). Under exclusive.sh.
D=~/buster-fast-bench/2826-claude
I=~/buster-fast-bench/3309-claude
CLANGDIR=$(ls -d ~/.cache/buster/benchpress-clang/*/bin 2>/dev/null | head -1)
export PATH=$CLANGDIR:$PATH
unset CPATH C_INCLUDE_PATH
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
echo "policies $* tree exp $(git -C $D/exp rev-parse HEAD) + exp2.patch $(sha256sum $D/exp2.patch | cut -c1-16)"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5
variants=()
for p in "$@"; do variants+=(--variant --tier1-memory-policy=$p); done
mkdir -p $D/tmp
cd $D/exp && taskset -c 2 ./build/compiler measure-tier1-programs --runs 11 --clang clang --sqlite "$sqlite" --speedtest $I/inputs --lua $I/inputs/lua-5.4.8/src --scripts $I/evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua --directory $D/tmp "${variants[@]}"
echo "rc=$?"
cat /proc/loadavg
