#!/bin/bash
# programs.sh NAME [OPTION...]: src's measure-tier1-programs as the 9700X job runs it (the frozen sqlite3.c, speedtest1.c
# and Lua 5.4.8 by their hashes, the cc3387f record's five scripts, tcc, 11 rounds, the code-size gates), with the 9700X
# job's clang 23.1.4 and OPTION... after it (--compiles 5), pinned to CPU 2, in one hold of the lock.
# results/NAME.txt has the output, results/NAME.env the tools' versions and hashes.
set -u
cd "$(dirname "$0")"
name=$1; shift
mkdir -p results
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
clang_dir=$(ls -d ~/.cache/buster/benchpress-clang/*/ | head -1)
export PATH="${clang_dir}bin:$PATH"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
inputs=$HOME/buster-fast-bench/138-tier1-quality-claude/inputs
{
    printf '0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d  %s\n' "$sqlite/sqlite3.c" | sha256sum --check
    printf 'b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675  %s\n' "$inputs/speedtest1.c" | sha256sum --check
    printf '4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae  %s\n' "$inputs/lua-5.4.8.tar.gz" | sha256sum --check
    printf '49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082  %s\n' "$(command -v tcc)" | sha256sum --check
    (cd "$inputs/scripts" && sha256sum *.lua)
    command -v clang; clang --version | head -1; tcc -v; uname -r
    echo "src $(cat src.commit)"; sha256sum src/build/compiler
} > "results/$name.env" 2>&1
./lock.sh bash -c "head -3 /var/lib/buster-9700x/owner; taskset -c 2 src/build/compiler measure-tier1-programs --check-code-size --runs 11 --clang clang --tcc $(command -v tcc) --sqlite $sqlite --speedtest $inputs --lua $inputs/lua-5.4.8/src --scripts $inputs/scripts --directory /tmp $*" > "results/$name.txt" 2>&1
echo "exit $?" >> "results/$name.txt"
