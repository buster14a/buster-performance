#!/bin/bash
# setup.sh: the #2694 workspace on benchpress.
set -eu
W=~/buster-fast-bench/2694-claude
mkdir -p $W/root/bin $W/scratch $W/ab
cd $W
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
cd repo && git fetch -q origin main
for t in "$@"; do
    name=${t%%=*}; rev=${t#*=}
    [ -d ../$name ] || git worktree add -q --detach ../$name $rev
    git -C ../$name rev-parse HEAD > ../$name/COMMIT
done
cd $W/root
for f in corpus predefines-znver5.h self-main.i; do [ -e $f ] || ln -s /home/david/buster-fast-bench/1340-droid/root/$f $f; done
cp -n ~/buster-fast-bench/1489-claude/root/workloads.sh workloads.sh
for v in aca9e53a 829eb71a main; do
    o=$v; [ $v = main ] && o=b7a95eed-old
    [ -e bin/compiler-old-$o ] || ln -s $(readlink -f ~/buster-fast-bench/1489-claude/root/bin/compiler-$v) bin/compiler-old-$o
done
ls -la bin
