#!/bin/bash
# programs.sh NAME [OPTION...]: measure-tier1-programs as the 9700X job's step runs it (11 rounds after one warm-up,
# clang and tcc from PATH, its directory on /tmp's tmpfs, which takes speedtest1's database), pinned to CPU 2, with
# the builds kept (--keep) and moved to scratch/NAME afterwards for the breakdown. Run it inside one hold of the
# lock: lock.sh ./programs.sh NAME. Results in results/NAME. OPTIONs go to the command (--variant ..., --runs N).
set -u
cd "$(dirname "$0")"
name=${1:?a name}; shift
out=results/$name
tmp=/tmp/claude-tier1-quality-$name
mkdir -p "$out" scratch "$tmp"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum src/build/compiler "$(command -v clang)" "$(command -v tcc)" > "$out/identity.txt"
clang --version | head -1 >> "$out/identity.txt"
cat src.commit >> "$out/identity.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
taskset -c 2 src/build/compiler measure-tier1-programs --runs 11 --clang clang --tcc "$(command -v tcc)" --sqlite "$sqlite" --speedtest "$PWD/inputs" \
    --lua "$PWD/inputs/lua-5.4.8/src" --scripts "$PWD/inputs/scripts" --directory "$tmp" --keep "$@" > "$out/measure-tier1-programs.log" 2>&1
echo "status $?" >> "$out/measure-tier1-programs.log"
# The kept builds, off the tmpfs: the executables, clang's objects, the checks' outputs.
rm -rf "scratch/$name"
mkdir -p "scratch/$name"
for directory in "$tmp"/measure-tier1-programs-*; do
    rm -rf "$directory/tmp" "$directory"/speedtest1.db*
    cp -a "$directory"/. "scratch/$name/"
done
rm -rf "$tmp"
(cd "scratch/$name" && sha256sum speedtest1-* lua-* *.o) > "$out/builds.sha256" 2>&1
date -u +%FT%TZ > "$out/done"
