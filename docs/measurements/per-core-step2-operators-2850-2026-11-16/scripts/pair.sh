#!/bin/bash
# pair.sh LABEL-A PATCH-A LABEL-B PATCH-B REVISION: two labels built, then their operators' kernels' figures on sqlite3.c
# in turn, three runs each, a whole and a lean record, a body a window and packed
cd "$(dirname "$0")"
a=$1; pa=$2; b=$3; pb=$4; revision=$5
./build-label.sh $a "$revision" "$pa" || exit 1
./build-label.sh $b "$revision" "$pb" || exit 1
for n in 1 2 3; do
    for label in $a $b; do
        ./facts1.sh $label "-ops" $n --facts-operators --passes 5
        ./facts1.sh $label "-leanops" $n --facts-lean --facts-operators --passes 5
        ./facts1.sh $label "-opspacked" $n --facts-operators --facts-packed --passes 5
        ./facts1.sh $label "-leanopspacked" $n --facts-lean --facts-operators --facts-packed --passes 5
        ./facts1.sh $label "" $n --passes 5
    done
done
echo pair-done
