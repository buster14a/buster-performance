#!/bin/bash
# #2995 and #2720 on the 9700X, one session: main and both PRs' heads built under the lock (a hold each), then
# time-runs under the lock (a hold each): #2995's shapes and sqlite3.c's -c, #2720's --tier1 -c of sqlite3.c.
# Usage: run.sh BASE_SHA BRANCH_2995 BRANCH_2720
set -u
base_sha=$1; b2995=$2; b2720=$3
dir=~/buster-fast-bench/2995-2720-claude
mkdir -p $dir && cd $dir
export EXCLUSIVE_OWNER=claude-2995-2720 EXCLUSIVE_TITLE="Unclaimed issues (avoiding 2850/2924): #2995 and #2720" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2995
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
for t in base h2995 h2720; do rm -rf $t; done; git -C repo worktree prune
git -C repo fetch -q origin $base_sha && git -C repo worktree add -q --detach ../base $base_sha
git -C repo fetch -q origin $b2995 && git -C repo worktree add -q --detach ../h2995 FETCH_HEAD
git -C repo fetch -q origin $b2720 && git -C repo worktree add -q --detach ../h2720 FETCH_HEAD
for t in base h2995 h2720; do echo "$t $(git -C $t rev-parse HEAD)"; done > COMMITS
for t in base h2995 h2720; do (cd $t && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > ../build-$t.log 2>&1; echo "build $t exit $?" >> ../build-$t.log); done
mkdir -p shapes
python3 - <<'PY'
gens = {
 'attr': lambda n: 'int x ' + '__attribute__((unused)) ' * n + ';',
 'case': lambda n: 'int f(int a) { switch (a) { ' + ''.join('case %d: ' % i for i in range(n)) + 'a++; } return a; }',
 'generic': lambda n: 'int x = ' + '_Generic(0, default: ' * n + '1' + ')' * n + ';',
 'typeof': lambda n: 'typeof(' * n + 'int' + ')' * n + ' x;',
}
for k, g in gens.items():
    for n in (10000, 40000):
        open('shapes/%s-%d.c' % (k, n), 'w').write(g(n) + '\n')
PY
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQ="--predefines $corpus/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
lists=""
for k in attr case generic typeof; do for n in 10000 40000; do lists="$lists --list -c -w shapes/$k-$n.c -o /dev/null"; done; done
~/buster-fast-bench/exclusive.sh taskset -c 2 h2995/build/compiler time-runs --runs 5 --warmups 1 --build base base/build/compiler --build head h2995/build/compiler $lists > shapes.txt 2>&1
echo "time-runs exit $?" >> shapes.txt
~/buster-fast-bench/exclusive.sh taskset -c 2 h2995/build/compiler time-runs --runs 11 --warmups 1 --build base base/build/compiler --build head h2995/build/compiler --list -c $SQ $corpus/sqlite/sqlite3.c -o /dev/null > sqlite-2995.txt 2>&1
echo "time-runs exit $?" >> sqlite-2995.txt
~/buster-fast-bench/exclusive.sh taskset -c 2 h2720/build/compiler time-runs --runs 11 --warmups 1 --build base base/build/compiler --build head h2720/build/compiler --list --tier1 -c $SQ $corpus/sqlite/sqlite3.c -o /dev/null > sqlite-2720.txt 2>&1
echo "time-runs exit $?" >> sqlite-2720.txt
echo done > DONE
