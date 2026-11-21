#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-shared-value-list
prev=../2850-codex-window-counters-current
rev=b3b6c30102a68f47ab94247471ca4dd9924933a2
cp "$prev/corpora.sh" "$prev/lock.sh" .
ln -s ../2850-codex-step2/inputs inputs
test -f inputs/lua-5.4.8/src/lapi.c
git -C "$prev/src" worktree add --detach "$PWD/tree" "$rev"
git -C tree apply ../shared-values.patch
./lock.sh bash -c 'cd tree && ./build.sh --config Release' > result/build.log 2>&1
cp tree/build/compiler result/slots
cp "$prev/result/compiler" result/ordinary
sha256sum result/ordinary result/slots shared-values.patch > result/sha256
echo "$rev" > result/revision
for round in 1 2 3 4 5 6 7; do
 flock -x ~/buster-fast-bench/2850-codex-step2/our-timing.lock bash shared-values-round.sh "$round"
done
date -u +%FT%TZ > result/all.done
