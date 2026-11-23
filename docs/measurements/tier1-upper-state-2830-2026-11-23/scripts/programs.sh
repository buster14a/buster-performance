#!/usr/bin/env bash
# programs.sh NAME: speedtest1 and Lua's five scripts by measure-tier1-programs of bin/NAME, with a --tier1 -march=znver5
# variant (the default target's --tier1 has no AVX, so #2830 changes nothing there), five rounds, one lock hold, CPU 2;
# the 9700X job's pinned inputs as #2755's record's programs.sh fetches them.
set -u
source "$(dirname "$0")/common.sh"
NAME=$1
cd $W || exit 1
export BUSTER_CI_CACHE=$HOME/.cache/buster/ci
O=$W/out/programs
mkdir -p $O inputs work-$NAME
sqlite=$W/corpus/sqlite
if [ ! -f inputs/speedtest1.c ]; then
    bash tree/tools/ci/cached-download.sh https://raw.githubusercontent.com/sqlite/sqlite/ccc132c5be20ab5c755c97a08d06b1b592fef330/test/speedtest1.c \
        b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675 inputs/speedtest1.c
    bash tree/tools/ci/cached-download.sh https://www.lua.org/ftp/lua-5.4.8.tar.gz \
        4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae inputs/lua-5.4.8.tar.gz
    tar -xzf inputs/lua-5.4.8.tar.gz -C inputs
    bash tree/tools/ci/fetch-performance.sh 818cfbbc0be238da287c16d8e2a91fd7275cf228 docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua evidence
fi
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check > $O/inputs.txt 2>&1
scripts=$W/evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
$LOCK bash -c "$(declare -f state); state programs-$NAME >&2; unset CPATH C_INCLUDE_PATH; taskset -c 2 $W/bin/$NAME measure-tier1-programs --runs 5 --clang $CLANG --sqlite $sqlite --speedtest $W/inputs --lua $W/inputs/lua-5.4.8/src --scripts $scripts --directory $W/work-$NAME --variant -march=znver5; echo exit \$?; state programs-end >&2" > $O/$NAME.txt 2>&1
rm -rf work-$NAME
