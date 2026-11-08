#!/bin/bash
# #1729 on top of #1352's dominators (#1730 at 0be4045e merged into main and into the branch): build both trees, then
# -c --tier1 of the issue's inputs, one lock hold per build and per point, and the head's profiles.
set -u
D=$HOME/buster-fast-bench/1729-opencode
cd "$D"
lockrun() { title=$1; shift; EXCLUSIVE_OWNER=opencode-1729 EXCLUSIVE_TITLE="#1729 SCCP phi: $title" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1729 ~/buster-fast-bench/exclusive.sh "$@" 2>&1 | grep -v '^exclusive.sh'; }
for t in ${DOM_BUILDS:-dbase dhead}; do
    (cd $t && lockrun "$t build" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../$t-build.log 2>&1)
    cp $t/build/compiler bin/$t
done
sha256sum bin/dbase bin/dhead > binaries-dom.sha256
: > results-dom.txt
for N in 1000 2000 4000 8000 16000; do
    for shape in ternary ifs same; do
        A=dbase B=dhead lockrun "dom $shape$N" "$D/point.sh" "dom-$shape$N" 5 -c --tier1 "inputs/$shape$N.c" >> results-dom.txt
        cmp -s "out/dom-$shape$N.dbase.o" "out/dom-$shape$N.dhead.o" && echo "dom-$shape$N objects identical" >> results-dom.txt || echo "dom-$shape$N objects DIFFER" >> results-dom.txt
    done
done
for shape in ternary ifs same; do
    lockrun "profile $shape" env A=dbase B=dhead "$D/profile.sh" "inputs/${shape}16000.c" > "profile-dom-$shape.txt"
done
echo done >> results-dom.txt
