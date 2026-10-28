#!/bin/bash
# Campaign B: builds the final tree, then five rounds of jobsB.txt (main's rule and the branch's on 8 lanes against one
# lane), fifteen jobs a lock hold, 40 s apart, into logB.txt; then c-testsuite's sweep (queueCT.sh).
D=~/buster-fast-bench/deferred-113-lanes-claude
cd "$D" || exit 1
echo $$ > "$D/chainB.pid"
"$D/build-trees.sh" final
if [ -x "$D/final/build/compiler" ]; then
    "$D/queue.sh" jobsB.txt logB.txt 5 15 40
    "$D/queueCT.sh"
else
    echo "the final build failed" >> "$D/builds.txt"
fi
