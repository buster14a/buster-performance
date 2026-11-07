#!/bin/bash
# setup.sh BRANCH_COMMIT: clones main (ec5f0f6b) and the branch's commit into this directory's main/ and branch/.
set -eu
d=~/buster-fast-bench/628-claude-tesla
cd "$d"
for t in main branch; do
    [ -d "$t/.git" ] || git clone -q https://github.com/buster14a/buster "$t"
done
(cd main && git fetch -q origin main && git checkout -q ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b)
(cd branch && git fetch -q origin claude/practical-tesla-2lgodi && git checkout -q "$1")
git -C main log -1 --format='main %H' ; git -C branch log -1 --format='branch %H'
