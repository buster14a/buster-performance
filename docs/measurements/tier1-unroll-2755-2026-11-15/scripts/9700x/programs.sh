#!/usr/bin/env bash
# programs.sh: speedtest1 and Lua's five scripts by measure-tier1-programs, the head compiler's --tier1 against
# --tier1 --tier1-passes=+unroll (its --variant), clang -O0 and -O2 and Tier 0, five rounds in one lock hold on CPU 2,
# with the 9700X job's pinned inputs (tools/ci/9700x.yml's step): the frozen sqlite3.c, SQLite 3.53.2's speedtest1.c and
# Lua 5.4.8 by their hashes, and the scripts of buster-performance's 818cfbbc. Started by systemd-run; writes
# programs.done.
set -u
cd ~/buster-fast-bench/2755-claude || exit 1
export EXCLUSIVE_OWNER=claude-2755
export EXCLUSIVE_TITLE="Issue 2755: Tier 1 loop unrolling (programs)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2755
export BUSTER_CI_CACHE=$HOME/.cache/buster/ci
LOCK=~/buster-fast-bench/exclusive.sh
TREE=~/buster-fast-bench/2755-claude/tree-head
mkdir -p programs/inputs programs/work
cd programs
rm -f programs.done
sqlite=~/buster-fast-bench/2755-claude/corpus/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check > inputs.txt 2>&1
bash $TREE/tools/ci/cached-download.sh https://raw.githubusercontent.com/sqlite/sqlite/ccc132c5be20ab5c755c97a08d06b1b592fef330/test/speedtest1.c \
    b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675 inputs/speedtest1.c >> inputs.txt 2>&1
bash $TREE/tools/ci/cached-download.sh https://www.lua.org/ftp/lua-5.4.8.tar.gz \
    4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae inputs/lua-5.4.8.tar.gz >> inputs.txt 2>&1
tar -xzf inputs/lua-5.4.8.tar.gz -C inputs
bash $TREE/tools/ci/fetch-performance.sh 818cfbbc0be238da287c16d8e2a91fd7275cf228 docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua evidence >> inputs.txt 2>&1
scripts=$PWD/evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; unset CPATH C_INCLUDE_PATH; taskset -c 2 $TREE/build/compiler measure-tier1-programs --runs 5 --clang $CLANG --sqlite $sqlite --speedtest $PWD/inputs --lua $PWD/inputs/lua-5.4.8/src --scripts $scripts --directory $PWD/work --variant --tier1-passes=+unroll" > programs.txt 2>&1
echo "exit $?" >> programs.txt
echo done > programs.done
