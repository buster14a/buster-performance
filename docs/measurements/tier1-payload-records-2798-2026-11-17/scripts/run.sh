#!/bin/bash
# #2798's main-vs-head measurements on the 9700X: Release builds of the merge-base and the PR head, each build, check
# and run its own exclusive.sh hold (ab takes the lock per run itself). Results in results/.
set -u
W=~/buster-fast-bench/2798-claude
X=~/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-2798
export EXCLUSIVE_TITLE="Problem 2798: Tier 1 for the 24-63-byte SSE, SSEUP records"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2798
BASE=$1
HEAD=$2
BRANCH=claude/dreamy-carson-xa5tf6
cd "$W"
mkdir -p results compilers
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main "$BRANCH"
[ -d base ] || git -C repo worktree add -q --detach "$W/base" "$BASE"
[ -d "head-$HEAD" ] || git -C repo worktree add -q --detach "$W/head-$HEAD" "$HEAD"
echo "$BASE" > base/COMMIT; echo "$HEAD" > "head-$HEAD/COMMIT"
for t in base "head-$HEAD"; do
    (cd "$W/$t" && "$X" env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > "results/build-${t%%-*}.log" 2>&1 || { echo "build $t failed"; exit 1; }
    cp "$W/$t/build/compiler" "compilers/compiler-${t%%-*}"
done
{ uname -a; grep -m1 "model name" /proc/cpuinfo; gcc --version | head -1; sha256sum compilers/*; } > results/identities.txt
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite="$corpus/sqlite"
sha256sum "$sqlite/sqlite3.c" >> results/identities.txt
options=(--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
# Drive check: both compile sqlite3.c by --tier1 (and Tier 0, the default), to the same object bytes.
"$X" bash -c "'$W/compilers/compiler-base' ${options[*]} -o /dev/shm/2798-base.o && '$W/compilers/compiler-head' ${options[*]} -o /dev/shm/2798-head.o && cmp /dev/shm/2798-base.o /dev/shm/2798-head.o && echo tier1-same-object && '$W/compilers/compiler-base' ${options[*]:1} -o /dev/shm/2798-base.o && '$W/compilers/compiler-head' ${options[*]:1} -o /dev/shm/2798-head.o && cmp /dev/shm/2798-base.o /dev/shm/2798-head.o && echo tier0-same-object; rm -f /dev/shm/2798-base.o /dev/shm/2798-head.o" > results/drive.txt 2>&1
cat results/drive.txt
# Correctness with GCC 16 too: the head's cross-check, its GCC runs and the strict wide-sse.c fixture among them.
(cd "$W/head-$HEAD" && "$X" ./build/compiler test-calling-convention --cross-check) > results/cross-check.txt 2>&1; echo "cross-check status $?" >> results/cross-check.txt
# The whole --tier1 compile, as whole processes: base, head and base again, 3 copies each, 3 runs a round, 3 rounds.
B="--build base $W/compilers/compiler-base --build head $W/compilers/compiler-head --build base-again $W/compilers/compiler-base"
"$W/compilers/compiler-head" ab --rounds 3 --cpu 2 --lock "$X" "$W/compilers/compiler-head" \
    -- time-runs --runs 3 --copies 3 $B --list "${options[@]}" -o /dev/shm/2798-ab.o > results/sqlite-ab.txt 2>&1
echo "sqlite ab status $?" >> results/sqlite-ab.txt
rm -f /dev/shm/2798-ab.o
echo done > results/DONE
