#!/bin/bash
# #2627 prototype, small bodies: the pieces' build again with SMALL=10 (a function body of up to 10 lines stays whole in
# every piece, as an inline one does) in n10; its test-checker; Develop's run time of whole, pieces and pieces10; and
# two rounds of both edits on n10. Each build and run its own hold of the lock.
set -eu
d=$HOME/buster-fast-bench/2627-claude
export EXCLUSIVE_OWNER=claude-2627 EXCLUSIVE_TITLE="#2627: the checker unit in pieces (prototype)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2627
L="$HOME/buster-fast-bench/exclusive.sh timeout 1200"
. $HOME/buster-fast-bench/2626-claude/scripts/env.sh
export BUSTER_HOST_ARCH=znver5
tree=$d/base/build/cmake/znver5
mkdir -p "$d/n10"
cp "$d/n/macros.h" "$d/n10/macros.h"
SMALL=10 "$d/proto/gen.sh" "$d/n10" "$tree" "$d/files.txt" 8 6
$L ninja -C "$d/n10" -j 8 > "$d/n10/first.log" 2>&1
cat "$d/n10/transform.log"
ls -la "$d/n10/compiler"
$L bash -c "cd $d/base && taskset -c 0-7 $d/n10/compiler test-checker > $d/results/test-checker10.log 2>&1; echo status \$? >> $d/results/test-checker10.log"
tail -2 "$d/results/test-checker10.log"
SIDES="whole pieces pieces10" RESULTS=runtime10 "$d/runtime.sh"
EDITS="append body" SIDES=pieces PIECES=n10 FIRST=4 "$d/edits.sh" 2
echo small-done
