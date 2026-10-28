#!/bin/bash
# Campaign A: builds main and head, then three rounds of jobsA.txt (the --every-lane grid on head, cold and warm, and
# main's 2 and 8 lanes), six jobs a lock hold, 40 s apart, into logA.txt.
D=~/buster-fast-bench/deferred-113-lanes-claude
cd "$D" || exit 1
echo $$ > "$D/chainA.pid"
"$D/build-trees.sh" main head
if [ -x "$D/main/build/compiler" ] && [ -x "$D/head/build/compiler" ]; then
    "$D/queue.sh" jobsA.txt logA.txt 3 6 40
else
    echo "a build failed" >> "$D/builds.txt"
fi
