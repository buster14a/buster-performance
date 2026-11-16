#!/bin/bash
# final.sh REVISION PATCH [RUNS]: the record's run. `base` is main at REVISION and `head` the same with PATCH, each built
# in one hold of the lock. On the three corpora, each run its own hold: base's whole kernel (step 1's follow-up's); head's
# three kernels of the leaves and lookups (whole, lean, loads); and head's operators' kernel with whole and with lean
# records; each with a body a window and with the windows packed to 384 records. Then the operators' kernel's profiles on
# sqlite3.c (whole and lean, a body a window; whole, packed) at 160 passes, and -c sqlite3.c as whole processes, base
# against head.
cd "$(dirname "$0")"
revision=$1; patch=$2; runs=${3:-3}
./build-label.sh base "$revision" || exit 1
./build-label.sh head "$revision" "$patch" || exit 1
./facts.sh base "" $runs --passes 5 --list 20
./facts.sh base "-packed" $runs --facts-packed --passes 5 --list 20
./facts.sh head "" $runs --passes 5 --list 20
./facts.sh head "-packed" $runs --facts-packed --passes 5 --list 20
./facts.sh head "-lean" $runs --facts-lean --passes 5 --list 20
./facts.sh head "-leanpacked" $runs --facts-lean --facts-packed --passes 5 --list 20
./facts.sh head "-loads" $runs --facts-loads --passes 5 --list 20
./facts.sh head "-loadspacked" $runs --facts-loads --facts-packed --passes 5 --list 20
./facts.sh head "-ops" $runs --facts-operators --passes 5 --list 20
./facts.sh head "-opspacked" $runs --facts-operators --facts-packed --passes 5 --list 20
./facts.sh head "-leanops" $runs --facts-lean --facts-operators --passes 5 --list 20
./facts.sh head "-leanopspacked" $runs --facts-lean --facts-operators --facts-packed --passes 5 --list 20
./profiles.sh head ops 160 --facts-operators
./profiles.sh head leanops 160 --facts-lean --facts-operators
./profiles.sh head opspacked 160 --facts-operators --facts-packed
./compile.sh base head 2
echo final-done
