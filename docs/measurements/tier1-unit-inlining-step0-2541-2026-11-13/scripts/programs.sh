#!/bin/bash
# programs.sh TREE [OPTION...]: measure-tier1-programs of TREE's Release compiler as the 9700X job's step runs it (clang
# and tcc from PATH, its directory on /tmp's tmpfs), pinned to CPU 2, with #138's record's inputs (speedtest1.c, Lua
# 5.4.8 and its five scripts, by their SHA-256 there) and the frozen sqlite3.c. Every program's output is checked before
# any timing (speedtest1's verification hash, each script's expected output). #138's record's programs.sh, by tree. Run
# inside one hold of the lock. results/programs-TREE/.
set -u
cd "$(dirname "$0")"
tree=${1:?a tree}; shift
out=results/programs-$tree
tmp=/tmp/claude-2541-programs-$tree
inputs=$HOME/buster-fast-bench/138-tier1-quality-claude/inputs
rm -rf "$tmp"
mkdir -p "$out" "$tmp"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$tree/build/compiler" "$(command -v clang)" "$(command -v tcc)" "$inputs/speedtest1.c" "$inputs"/scripts/*.lua > "$out/identity.txt"
clang --version | head -1 >> "$out/identity.txt"
cat "$tree.commit" >> "$out/identity.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
taskset -c 2 "$tree/build/compiler" measure-tier1-programs --clang clang --tcc "$(command -v tcc)" --sqlite "$sqlite" --speedtest "$inputs" \
    --lua "$inputs/lua-5.4.8/src" --scripts "$inputs/scripts" --directory "$tmp" "$@" > "$out/measure-tier1-programs.log" 2>&1
echo "status $?" >> "$out/measure-tier1-programs.log"
rm -rf "$tmp"
date -u +%FT%TZ > "$out/done"
