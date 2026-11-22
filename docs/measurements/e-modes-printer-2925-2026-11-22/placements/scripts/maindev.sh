#!/bin/bash
# Main's (the bundle's origin/main) Develop build and the two preprocessor-against-clang blocks that fail on this host,
# each under the 9700X's lock alone, to compare their failing items with the branch's (#2925).
set -u
D=~/buster-fast-bench/1380-claude-2925
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
export PATH=$(dirname $(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)):$PATH
[ -d $D/maindev ] || git clone -q --no-checkout $D/final $D/maindev
cd $D/maindev
git checkout -q --detach $(git -C $D/final rev-parse bundle/main) && git log --oneline -1
~/buster-fast-bench/exclusive.sh ./build.sh > $D/build-maindev.log 2>&1
echo "develop maindev exit $?"
for t in maindev final; do
    awk '/^== /{keep = index($0, "Test the preprocessor on the repository\x27s translation units against clang") == 4 || index($0, "Test the preprocessor\x27s cases against clang (part 2 of 4)") == 4} keep' $D/$t/tools/ci/correctness.tests > $D/two-$t.list
    (cd $D/$t && ~/buster-fast-bench/exclusive.sh timeout -k 10 300 env BUSTER_COMPILER=$D/$t/build/cmake/native/Develop/compiler $D/$t/build/cmake/native/Develop/compiler parallel --jobs 8 --timeout 280 < $D/two-$t.list > $D/two-$t.log 2>&1)
    echo "two blocks $t exit $?"
done
echo "maindev done"
