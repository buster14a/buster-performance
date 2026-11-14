#!/bin/bash
# #2531 leftovers, the view's huge pages: main 2909b2c with the no-view probe (tree m9), thp counts and attribution.
cd ~/buster-fast-bench/2531-step3c-claude
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
if [ ! -x m9/build/compiler ]; then
    rm -rf m9 && git clone -q --reference ../1840-fma/repo https://github.com/buster14a/buster m9 && git -C m9 checkout -q 2909b2c2e && git -C m9 apply ../2531-step3c-claude/noview.patch && git -C m9 diff --stat
    x ./build.sh m9
fi
for r in 1 2; do x ./run9.sh thp m9 $r on noview off; done
x ./run9.sh kthp m9 on
x ./run9.sh kthp m9 noview
echo "queue14 done"
