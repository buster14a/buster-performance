#!/bin/bash
cd ~/buster-fast-bench/2531-step3c-claude
true
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
x ./run10.sh kthp2 m9 on
x ./run10.sh kthp2 m9 noview
echo "queue15 done"
