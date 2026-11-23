#!/bin/bash
set -e
D=/tmp/3335-claude
mkdir -p $D && cd $D
export EXCLUSIVE_OWNER=claude-3335 EXCLUSIVE_TITLE="buster #3335 Tier 0 vzeroupper" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3335
for t in base mine; do
  if [ ! -d $t ]; then git clone -q https://github.com/buster14a/buster $t; fi
  (cd $t && git fetch -q origin claude/3335-tier0-vzeroupper && git checkout -q FETCH_HEAD)
done
(cd base && git checkout -q HEAD~1)
for t in base mine; do
  (cd $t && git log --oneline -1 && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release 2>&1 | tail -2)
done
echo SETUP DONE
