#!/bin/bash
# #2113's main-vs-head measurements on the 9700X: Release builds of the merge-base and the PR head, each build, check
# and run its own exclusive.sh hold (ab takes the lock per run itself). Results in results/.
set -u
W=~/buster-fast-bench/2113-claude
X=~/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-2113
export EXCLUSIVE_TITLE="Problem 2113: 24-63-byte SSE, SSEUP records"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2113
BASE=2ebfe68a856613e300231520af5e7ec5627708b6
HEAD=$1
cd "$W"
mkdir -p results compilers
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main claude/loving-tesla-d9pw4x
[ -d base ] || git -C repo worktree add -q --detach "$W/base" "$BASE"
[ -d "head-$HEAD" ] || git -C repo worktree add -q --detach "$W/head-$HEAD" "$HEAD"
echo "$BASE" > base/COMMIT; echo "$HEAD" > "head-$HEAD/COMMIT"
for t in base "head-$HEAD"; do
    (cd "$W/$t" && "$X" env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > "results/build-$t.log" 2>&1 || { echo "build $t failed"; exit 1; }
    cp "$W/$t/build/compiler" "compilers/compiler-${t%%-*}"
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite="$corpus/sqlite"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
# Drive check: both compile sqlite3.c, to the same object bytes.
"$X" bash -c "'$W/compilers/compiler-base' ${options[*]} -o /tmp/2113-base.o && '$W/compilers/compiler-head' ${options[*]} -o /tmp/2113-head.o && cmp /tmp/2113-base.o /tmp/2113-head.o && echo same-object" > results/drive.txt 2>&1
cat results/drive.txt
# Correctness with GCC 16 too: the head's cross-check, its GCC runs among them.
(cd "$W/head-$HEAD" && "$X" ./build/compiler test-calling-convention --cross-check) > results/cross-check.txt 2>&1; echo "cross-check status $?" >> results/cross-check.txt
# The whole compile, as whole processes: base, head and base again, 3 copies each, 3 runs a round, 3 rounds.
B="--build base $W/compilers/compiler-base --build head $W/compilers/compiler-head --build base-again $W/compilers/compiler-base"
"$W/compilers/compiler-head" ab --rounds 3 --cpu 2 --lock "$X" "$W/compilers/compiler-head" \
    -- time-runs --runs 3 --copies 3 $B --list "${options[@]}" -o /tmp/2113-ab.o > results/sqlite-ab.txt 2>&1
echo "sqlite ab status $?" >> results/sqlite-ab.txt
# The module's own benchmark, base and head in a Williams order.
"$W/compilers/compiler-head" ab --rounds 6 --cpu 2 --lock "$X" "$W/compilers/compiler-base" "$W/compilers/compiler-head" \
    -- benchmark-calling-convention > results/module-ab.txt 2>&1
echo "module ab status $?" >> results/module-ab.txt
echo done > results/DONE
