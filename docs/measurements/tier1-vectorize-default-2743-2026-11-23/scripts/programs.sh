#!/usr/bin/env bash
# programs.sh TREE NAME [VARIANT...]: TREE's measure-tier1-programs (speedtest1 and Lua's five scripts by Tier 0,
# --tier1 and each `--tier1 VARIANT`, clang -O0 and -O2; no tcc) with --check-code-size and 11 rounds, pinned to CPU 2,
# under one hold of the 9700X lock; its output in out/programs-NAME.txt.
set -u
R=~/buster-fast-bench/2743-claude-default
cd $R || exit 1
export EXCLUSIVE_OWNER=claude-2743-default
export EXCLUSIVE_TITLE="buster #2743: Tier 1 loop vectorizer by default"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
TREE=$1
NAME=$2
shift 2
variants=()
for v in "$@"; do variants+=(--variant "$v"); done
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
SQLITE=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$R/inputs/programs
mkdir -p out work/programs-$NAME
unset CPATH C_INCLUDE_PATH
~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $R/holds.txt; { echo \"\$(date -u +%FT%TZ) \$(cat /proc/loadavg)\"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> $R/busy.txt; PATH=$(dirname $CLANG):\$PATH timeout -k 5 1500 taskset -c 2 $R/$TREE/build/compiler measure-tier1-programs ${CHECK---check-code-size} --runs 11 --clang $CLANG --sqlite $SQLITE --speedtest $IN --lua $IN/lua-5.4.8/src --scripts $R/inputs/lua --directory $R/work/programs-$NAME ${variants[*]}" > out/programs-$NAME.txt 2>&1
echo "exit $?" >> out/programs-$NAME.txt
