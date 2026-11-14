#!/bin/bash
cd ~/buster-fast-bench/2531-step3c-claude
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
x ./run4.sh warm m9
x ./run11.sh sqlitepasses m9
echo "queue16 done"
