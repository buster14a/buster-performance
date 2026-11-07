#!/bin/bash
# #1450 item 5: per-stage Tier 1 instruction counts, #1413's main 9f416b20 against its head db03f52a.
set -eu
W=~/buster-fast-bench/1450-claude
mkdir -p $W && cd $W
export EXCLUSIVE_OWNER=claude-1450 EXCLUSIVE_TITLE='GitHub issue #1450' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1450
SRCREPO=~/buster-fast-bench/141-final-claude/head
for pair in "a 9f416b20" "b db03f52a"; do
  set -- $pair
  if [ ! -d $1 ]; then
    git clone -q --shared $SRCREPO $1
    (cd $1 && (git cat-file -e $2^{commit} 2>/dev/null || git fetch -q https://github.com/buster14a/buster $2) && git checkout -q $2)
  fi
  (cd $1 && git checkout -q -- src/buster/compiler/c_check_tier1.c && python3 $W/patch_stages.py src/buster/compiler/c_check_tier1.c)
done
for t in a b; do
  (cd $t && ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../build-$t.log 2>&1; echo "build $t exit=$?" >> ../build-$t.log)
done
echo setup-done > setup.done
