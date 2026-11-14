#!/bin/bash
cd ~/buster-fast-bench/2531-step3c-claude
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
git -C m9 checkout -q -- . && git -C m9 apply ../probe2.patch && git -C m9 diff --stat
x ./build.sh m9
for r in 1 2; do x ./run13.sh thp m9 $r on unitbase noview; done
echo "queue18 done"
