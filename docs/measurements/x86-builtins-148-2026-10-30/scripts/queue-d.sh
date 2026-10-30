#!/bin/bash
# Builds main b424fe30 and #148's x86 builtins head, then runs measure-ab.sh between them.
cd ~/buster-fast-bench/solve-147-claude
echo $$ > queue-d.pid
EXCLUSIVE_TITLE="solve #137 #147 #148 (#148: x86 builtins A/B)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148 ./build-tree.sh main-b424fe30
EXCLUSIVE_TITLE="solve #137 #147 #148 (#148: x86 builtins A/B)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148 ./build-tree.sh x86-7fa5820a
./measure-ab.sh main-b424fe30 x86-7fa5820a x86 "solve #137 #147 #148 (#148: x86 builtins A/B)" https://github.com/buster14a/buster/issues/148 > measure-x86.out 2>&1
echo "x86: status $?"
echo done
