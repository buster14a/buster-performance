#!/bin/bash
# confirm.sh REVISION PATCH [RUNS]: the pull request's own sources, after the record's run. `pr` is main at REVISION
# with PATCH (the record's `head` with the lists' twin's order check and the fixture's four statements, neither in a
# timed pass), built in one hold of the lock; then its operators' kernel with whole and with lean records, a body a
# window and packed, on the three corpora, each run its own hold.
cd "$(dirname "$0")"
revision=$1; patch=$2; runs=${3:-3}
./build-label.sh pr "$revision" "$patch" || exit 1
./facts.sh pr "-ops" $runs --facts-operators --passes 5 --list 20
./facts.sh pr "-opspacked" $runs --facts-operators --facts-packed --passes 5 --list 20
./facts.sh pr "-leanops" $runs --facts-lean --facts-operators --passes 5 --list 20
./facts.sh pr "-leanopspacked" $runs --facts-lean --facts-operators --facts-packed --passes 5 --list 20
echo confirm-done
