#!/bin/bash
# follow.sh REVISION PATCH [RUNS]: the follow-up's record run. `base` is main at REVISION and `head` the same with
# PATCH, each built in one hold of the lock. On the three corpora, each run its own hold: base's whole kernel and
# head's three kernels (whole, lean, loads), each with a body a window and with the windows packed to 384 records. Then
# head's three kernels' profiles on sqlite3.c, packed (profiles.sh), and -c sqlite3.c as whole processes, base
# against head. (The record's run of this profiled 40 passes a run and had the whole kernel's files overwritten by the
# lean one's: `./profiles.sh head 160 whole lean loads` ran after it, and its profiles are the record's.)
cd "$(dirname "$0")"
revision=$1; patch=$2; runs=${3:-3}
./build-label.sh base "$revision" || exit 1
./build-label.sh head "$revision" "$patch" || exit 1
./facts.sh base "" $runs --passes 5 --list 20
./facts.sh base "-packed" $runs --facts-packed --passes 5 --list 20
./facts.sh head "" $runs --passes 5 --list 20
./facts.sh head "-lean" $runs --facts-lean --passes 5 --list 20
./facts.sh head "-loads" $runs --facts-loads --passes 5 --list 20
./facts.sh head "-packed" $runs --facts-packed --passes 5 --list 20
./facts.sh head "-leanpacked" $runs --facts-lean --facts-packed --passes 5 --list 20
./facts.sh head "-loadspacked" $runs --facts-loads --facts-packed --passes 5 --list 20
./profiles.sh head 160 whole lean loads
./compile.sh base head 2
echo follow-done
