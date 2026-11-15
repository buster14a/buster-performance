#!/bin/bash
# ordered.sh LABEL REVISION PATCH [RUNS]: build LABEL from main REVISION with PATCH, then on the three corpora, each run
# its own hold of the lock, the loads' kernel by classes and in order, with a body a window and with the windows packed
# to 384 records.
cd "$(dirname "$0")"
label=$1; revision=$2; patch=$3; runs=${4:-3}
./build-label.sh "$label" "$revision" "$patch" || exit 1
./facts.sh "$label" "-loads" $runs --facts-loads --passes 5 --list 20
./facts.sh "$label" "-ordered" $runs --facts-ordered --passes 5 --list 20
./facts.sh "$label" "-loadspacked" $runs --facts-loads --facts-packed --passes 5 --list 20
./facts.sh "$label" "-orderedpacked" $runs --facts-ordered --facts-packed --passes 5 --list 20
echo ordered-done
