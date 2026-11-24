#!/bin/bash
# #2924's x86 tables' twins, pieces (a) Zen 5 lookup and (b) target forms: base main 387faaea and both heads on the 9700X,
# Release, every run under the lock (timeout inside it).
# 1. -c (Tier 0) and -c --tier1 objects of sqlite3.c and buster's main.c by base and each head, byte by byte;
# 2. on each head: its module's tests, its callers' tests and benchmark, the call graph's and the unity ownership check.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD/ab
mkdir -p $D/logs $D/compilers
. ./env.sh
L=~/buster-fast-bench/exclusive.sh
declare -A C=([base]=387faaea [zen5]=54de9793dd4f26d800cccd088adeeaa43abce6cb [target]=7fd5296f8022525697223a25a33cccf1c8584b52)
for side in base zen5 target; do
    if [ ! -d $D/src-$side ]; then git clone -q --shared $PWD/gate $D/src-$side || exit 1; fi
    git -C $D/src-$side fetch -q https://github.com/buster14a/buster main claude/2924-x86-zen5 claude/2924-x86-target || { echo "fetch failed" >> $D/logs/status.txt; exit 1; }
    git -C $D/src-$side checkout -q --detach ${C[$side]} && git -C $D/src-$side reset -q --hard
    echo "$side $(git -C $D/src-$side rev-parse HEAD)" >> $D/logs/commits.txt
    (cd $D/src-$side && $L timeout -k 5 900 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> $D/logs/status.txt; exit 1; }
    cp $D/src-$side/build/compiler $D/compilers/$side
done
sha256sum $D/compilers/* > $D/logs/compilers.sha256
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
B=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char -fno-strict-aliasing "$D/src-base/src/buster/compiler/main.c")
for side in base zen5 target; do
    for mode in tier0 tier1; do
        if [ $mode = tier1 ]; then opt=(--tier1); else opt=(); fi
        $L timeout -k 5 600 bash -c '"$0" "$@"' $D/compilers/$side -c "${opt[@]}" -o $D/obj-$side-$mode-sqlite.o "${S[@]}" > $D/logs/obj-$side-$mode-sqlite.log 2>&1; echo "obj $side $mode sqlite: $?" >> $D/logs/status.txt
        $L timeout -k 5 600 bash -c '"$0" "$@"' $D/compilers/$side -c "${opt[@]}" -o $D/obj-$side-$mode-main.o "${B[@]}" > $D/logs/obj-$side-$mode-main.log 2>&1; echo "obj $side $mode main: $?" >> $D/logs/status.txt
    done
done
for side in zen5 target; do for mode in tier0 tier1; do for f in sqlite main; do
    cmp -s $D/obj-base-$mode-$f.o $D/obj-$side-$mode-$f.o; echo "objects $side $mode $f identical to base: $? (0 = yes)" >> $D/logs/status.txt
done; done; done
run_tests() {
    local side=$1; shift
    local i=0
    while IFS= read -r t; do
        [ -z "$t" ] && continue
        i=$((i+1))
        (cd $D/src-$side && $L timeout -k 5 280 taskset -c 2 bash -c "./build/compiler $t") > "$D/logs/$side-t$i.log" 2>&1
        echo "$side $t: $?" >> $D/logs/status.txt
    done
}
run_tests zen5 <<'LIST'
test-x86-zen5
test-tier1-select
benchmark-x86-zen5
benchmark-x86-zen5 --after-scalar 200
test-tier1-schedule
LIST
run_tests target <<'LIST'
test-x86-target
benchmark-x86-target
benchmark-x86-target --after-predefines 200
test-builtin-terminal-helpers
test-tier0
LIST
for side in zen5 target; do
    (cd $D/src-$side && cc -std=c17 -O2 -o $D/br-$side tools/ci/build_regression.c && $L timeout -k 5 600 $D/br-$side --ownership-only "$PWD/build/cmake/native/Release/compiler") > "$D/logs/ownership-$side.log" 2>&1; echo "ownership $side: $?" >> $D/logs/status.txt
done
rm -f $D/obj-*.o
echo done >> $D/logs/status.txt
