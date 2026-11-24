#!/bin/bash
# Objects of buster's main.c and c-testsuite's subset by base and head, in four LICM modes.
set -u
S=$(dirname "$0")
cd /home/user/buster
mapfile -d '' -t flags < <(./build.sh print-compile-flags 2>/dev/null)
CT=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
for mode in tier1 licm hoist scalar-licm; do
    case $mode in
        tier1) opt=(--tier1) ;;
        licm) opt=(--tier1 --tier1-passes=+licm) ;;
        hoist) opt=(--tier1 --tier1-passes=+hoist) ;;
        scalar-licm) opt=(--scalar --tier1 --tier1-passes=+licm) ;;
    esac
    for side in base head; do
        o=$S/out/$mode/$side; rm -rf $o; mkdir -p $o/ct
        $S/$side -c "${opt[@]}" --lanes 1 "${flags[@]}" -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c -o $o/main.o > /dev/null 2> $o/main.stderr; echo "$mode $side main: $?"
        (cd $o/ct && for f in $CT; do $S/$side -c "${opt[@]}" --lanes 1 /home/user/buster/$f 2>> ../ct.stderr > /dev/null || echo "fail $f" >> ../ct.fail; done)
    done
    n=0; d=0
    for f in $(cd $S/out/$mode/base && find . -name '*.o' | sort); do n=$((n+1)); cmp -s $S/out/$mode/base/$f $S/out/$mode/head/$f || { d=$((d+1)); echo "differs $mode $f"; }; done
    cmp -s $S/out/$mode/base/ct.stderr $S/out/$mode/head/ct.stderr; s1=$?
    cmp -s $S/out/$mode/base/main.stderr $S/out/$mode/head/main.stderr; s2=$?
    echo "objects $mode: $n compared, $d differ; stderr differ: ct=$s1 main=$s2"
done
