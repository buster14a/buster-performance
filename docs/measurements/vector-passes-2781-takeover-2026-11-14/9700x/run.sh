#!/bin/bash
# buster#2781 on the 9700X: main 2ebfe68a (base) against PR #2790's head, both Release.
# Every build and timed run takes the lock through exclusive.sh, one run per hold.
set -euo pipefail
W=$HOME/buster-fast-bench/2781-claude
R=$W/repo
X=$HOME/buster-fast-bench/exclusive.sh
CLANG=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang
SQLITE=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
BASE=2ebfe68a856613e300231520af5e7ec5627708b6
HEAD=${HEAD:?}
export EXCLUSIVE_OWNER=claude-2781
export EXCLUSIVE_TITLE="Tier 1: value numbering and LICM on vector and mask values by default (#2781)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2790
O=$W/results
mkdir -p $O $W/compilers $W/inputs
echo $$ > $W/run.pid
step() { echo "== $(date -u +%FT%TZ) $*" | tee -a $O/steps.log; }

step fetch
git -C $R fetch -q origin main droid/vector-passes-1344
for t in base head; do
    c=$BASE; [ $t = head ] && c=$HEAD
    if [ ! -d $W/$t ]; then git -C $R worktree add -q --detach $W/$t $c; fi
    git -C $W/$t checkout -q --detach $c
    git -C $W/$t rev-parse HEAD > $O/commit-$t.txt
done

step lua
if [ ! -d $W/inputs/lua-5.4.8 ]; then
    curl -sSfL -o $W/inputs/lua-5.4.8.tar.gz https://www.lua.org/ftp/lua-5.4.8.tar.gz
    echo "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae  $W/inputs/lua-5.4.8.tar.gz" | sha256sum --check
    tar -xzf $W/inputs/lua-5.4.8.tar.gz -C $W/inputs
fi
echo "0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d  $SQLITE" | sha256sum --check

for t in base head; do
    step build $t
    (cd $W/$t && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > $O/build-$t.log 2>&1
    cp $W/$t/build/compiler $W/compilers/$t
    test -x $W/compilers/$t
done
sha256sum $W/compilers/base $W/compilers/head > $O/compilers.sha256
$CLANG --version | head -1 > $O/clang.txt

step neutrality
cat > $W/neutral.sh <<'INNER'
#!/bin/bash
set -euo pipefail
W=$1; SQLITE=$2; N=$W/neutral
state() { ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; }
rm -rf $N; mkdir -p $N
state > $N/state-before.txt
for v in base:base:default head:head:default head:head:-vectors; do
    IFS=: read -r name compiler passes <<< "$v"
    extra=(); [ "$passes" != default ] && extra=(--tier1-passes=$passes)
    tag=$name-$passes
    $W/compilers/$compiler --tier1 --tier1-report "${extra[@]}" --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -march=znver5 -c $SQLITE -o $N/sqlite3-$tag.o > $N/sqlite3-$tag.report 2>&1
    for f in $W/inputs/lua-5.4.8/src/*.c; do
        b=$(basename $f .c); [ $b = lua ] || [ $b = luac ] && continue
        $W/compilers/$compiler --tier1 --tier1-report "${extra[@]}" -march=znver5 -DLUA_USE_LINUX -c $f -o $N/lua-$b-$tag.o > $N/lua-$b-$tag.report 2>&1
    done
    (cd $W/head && $W/compilers/$compiler --tier1 --tier1-report "${extra[@]}" -march=znver5 -Isrc -fwrapv -funsigned-char -c src/buster/compiler/c_lexer_benchmark.c -o $N/lexer-$tag.o > $N/lexer-$tag.report 2>&1)
done
state > $N/state-after.txt
(cd $N && sha256sum *.o) > $N/objects.sha256
INNER
chmod +x $W/neutral.sh
$X $W/neutral.sh $W $SQLITE > $O/neutral.log 2>&1
cp $W/neutral/objects.sha256 $W/neutral/state-*.txt $O/
mkdir -p $O/neutral-reports && cp $W/neutral/*.report $O/neutral-reports/

step rows
rm -rf /tmp/2781-claude-rows; mkdir -p /tmp/2781-claude-rows
(cd $W/head && $X bash -c "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; taskset -c 2 $W/compilers/head measure-tier1-rows --runs 11 --clang $CLANG --base $W/compilers/base --march znver5 --lexer src/buster/compiler/c_lexer.c --directory /tmp/2781-claude-rows; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg") > $O/rows.log 2>&1

step compile-sqlite
B="--build base $W/compilers/base --build head $W/compilers/head --build base-again $W/compilers/base"
mkdir -p /tmp/2781-claude-copies
(cd $W/head && ./build/compiler ab --rounds 3 --cpu 2 --lock $X $W/compilers/head -- time-runs --runs 3 --copies 3 $B --directory /tmp/2781-claude-copies \
    --list --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -march=znver5 -c $SQLITE -o /tmp/2781-claude-copies/sqlite3.o) > $O/compile-sqlite.log 2>&1

step compile-lexer
(cd $W/head && ./build/compiler ab --rounds 3 --cpu 2 --lock $X $W/compilers/head -- time-runs --runs 5 --copies 3 $B --directory /tmp/2781-claude-copies \
    --list --tier1 -march=znver5 -I$W/head/src -fwrapv -funsigned-char -c $W/head/src/buster/compiler/c_lexer_benchmark.c -o /tmp/2781-claude-copies/lexer.o) > $O/compile-lexer.log 2>&1

rm -rf /tmp/2781-claude-rows /tmp/2781-claude-copies
step done
touch $O/done
