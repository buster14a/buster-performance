#!/bin/bash
# round8.sh: build main e98426b2 and the #1167 head 7676f9cb (a hold each), their receipts, then the checked scripts,
# objects-checked.sh and ab-checked.sh; any step's failure ends the round with its status.
set -euo pipefail
cd ~/buster-fast-bench/claude-628
export EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main-e98426b2 head-7676f9cb; do
    (cd "$tree" && ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1)
    echo "build $tree status 0"
done
./receipts8.sh
./objects-checked.sh main-e98426b2 head-7676f9cb obj8
./ab-checked.sh main-e98426b2 head-7676f9cb ab8
echo round8-done
