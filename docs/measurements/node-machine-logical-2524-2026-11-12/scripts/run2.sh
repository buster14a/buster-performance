#!/bin/bash
# run2.sh COMMIT: after run.sh, this change's next commit built, compared on the corpora, timed, and -c A/B against main.
set -u
cd "$(dirname "$0")"
commit=$1
until test -f .done; do sleep 30; done
git -C src fetch -q origin claude/funny-clarke-l9fzub
git -C src checkout -q --detach "$commit"
label=$(git -C src rev-parse --short=8 HEAD)
./build.sh src "$label"
./corpora.sh "$label"
./time.sh "$label"
./ab.sh main "$label"
date -u +%FT%TZ > .done2
