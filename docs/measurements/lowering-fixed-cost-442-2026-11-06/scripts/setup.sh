#!/bin/bash
# #442's rebaseline on the 9700X: the c-testsuite checkout, the synthetic units and the baseline trees.
set -e
cd ~/buster-fast-bench/442-claude-rebase
if [ ! -d cts/.git ]; then
    git init -q --template= cts
    git -C cts fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
    git -C cts checkout -q FETCH_HEAD
fi
python3 scripts/synthetic.py synthetic 200
python3 scripts/synthetic.py synthetic 2000
git -C buster.git fetch -q origin main 3bfb4a72a51f4a7872090905d52f92b95b3e1375 54703dcf6607ecc1c7267869e46e59ab225ab393 || true
export EXCLUSIVE_OWNER=claude-442 EXCLUSIVE_TITLE="Solve 442" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/442
export LOCK=$HOME/buster-fast-bench/exclusive.sh
scripts/build-trees.sh buster.git trees main418=3bfb4a72a51f4a7872090905d52f92b95b3e1375:old pr418=54703dcf6607ecc1c7267869e46e59ab225ab393:old now=ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b:now
echo setup-done
