#!/usr/bin/env bash
# compile.sh: the head compiler's --tier1 -c of the frozen sqlite3.c (the 9700X job's -c flags) and of its own main.c
# (the repository's smoke flags at znver5), one lane each, by the default pipeline and with --tier1-passes=+unroll. Three
# lock holds: a drive check (each command once with its status and its unroller's report, the objects' sizes, and the base
# compiler's default objects of both inputs, which must be the head's byte for byte: the unroller is off by default);
# then measure-compile --runs 11 --variant --tier1-passes=+unroll of each input on CPU 2 (whole processes in a Williams
# design's order, with user cycles and instructions and each stage's medians). Started by pipeline2.sh; writes
# compile.done.
set -u
cd ~/buster-fast-bench/2755-claude/compile || exit 1
export EXCLUSIVE_OWNER=claude-2755
export EXCLUSIVE_TITLE="Issue 2755: Tier 1 loop unrolling (compile cost)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2755
LOCK=~/buster-fast-bench/exclusive.sh
HEAD=~/buster-fast-bench/2755-claude/tree-head/build/compiler
BASE=~/buster-fast-bench/2755-claude/tree-base/build/compiler
CORPUS=~/buster-fast-bench/2755-claude/corpus
TREE=~/buster-fast-bench/2755-claude/tree-head
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
rm -f compile.done
$CLANG -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > predefines-znver5.h
SQL="--lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$CORPUS/sqlite $CORPUS/sqlite/sqlite3.c"
MAIN="--lanes 1 -march=znver5 -I$TREE/src -fwrapv -funsigned-char -fno-strict-aliasing --predefines $PWD/predefines-znver5.h $TREE/src/buster/compiler/main.c"
{
    date -u +%FT%TZ
    echo "head commit: $(cat $TREE/COMMIT)"
    echo "base commit: $(cat ~/buster-fast-bench/2755-claude/tree-base/COMMIT)"
    sha256sum $HEAD $BASE
} > env.txt
cat > drive.sh <<INNER
#!/usr/bin/env bash
head -1 /var/lib/buster-9700x/owner >> holds.txt
for input in sqlite main; do
    [ \$input = sqlite ] && args="$SQL" || args="$MAIN"
    $HEAD --tier1 --tier1-report -c \$args -o head-\$input-default.o > report-\$input-default.txt 2>&1
    echo "\$input default status \$?"
    $HEAD --tier1 --tier1-report --tier1-passes=+unroll -c \$args -o head-\$input-unroll.o > report-\$input-unroll.txt 2>&1
    echo "\$input unroll status \$?"
    $BASE --tier1 -c \$args -o base-\$input-default.o > base-\$input.txt 2>&1
    echo "\$input base status \$?"
    cmp base-\$input-default.o head-\$input-default.o && echo "\$input: the base's and the head's default objects are identical"
done
size head-*.o base-*.o
INNER
chmod +x drive.sh
$LOCK ./drive.sh > drive.txt 2>&1
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; taskset -c 2 $HEAD measure-compile --runs 11 --variant --tier1-passes=+unroll -- --tier1 -c $SQL" > measure-sqlite.txt 2>&1
echo "sqlite exit $?" >> measure-sqlite.txt
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; taskset -c 2 $HEAD measure-compile --runs 11 --variant --tier1-passes=+unroll -- --tier1 -c $MAIN" > measure-main.txt 2>&1
echo "main exit $?" >> measure-main.txt
echo done > compile.done
