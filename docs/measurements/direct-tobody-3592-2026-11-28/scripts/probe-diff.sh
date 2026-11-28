#!/bin/bash
# probe-diff.sh COMPILER DIR: each DIR/p*.c by -std=gnu99 -O2 -c (glibc's tolower as __tobody), by default and with
# --no-direct: exit status and standard error compared, and the path the default run took (direct, or the direct path's
# refusing rule from BUSTER_TEST_DIRECT_BAILS).
set -uo pipefail
B=$1; dir=$2; t=$(mktemp -d); nd=0
for f in "$dir"/p*.c; do
    BUSTER_TEST_DIRECT_BAILS=$t/b "$B" --lanes 1 -std=gnu99 -O2 -c "$f" -o $t/d.o > $t/d.err 2>&1; ds=$?
    "$B" --no-direct --lanes 1 -std=gnu99 -O2 -c "$f" -o $t/n.o > $t/n.err 2>&1; ns=$?
    if [ "$ds" = 0 ] && [ ! -s $t/b ]; then path=direct; else path="left($(cut -f1 $t/b 2>/dev/null | head -1))"; fi
    if cmp -s $t/d.err $t/n.err && [ $ds = $ns ]; then same=same; else same=DIFFERENT; nd=$((nd + 1)); fi
    echo "$(basename "$f") status=$ds/$ns $same $path :: $(sed -n 4p "$f")"
    rm -f $t/b $t/d.o $t/n.o
done
echo "different: $nd"; rm -rf "$t"
