#!/bin/bash
set -e
D=~/buster-fast-bench/1833-claude
mkdir -p $D && cd $D
[ -d repo ] || git clone -q https://github.com/buster14a/buster repo
cd repo && git fetch -q origin main claude/bit-field-units-port
for r in base:cb608c1f6 merge:3a9a28c3a head:3235d260e; do n=${r%%:*}; c=${r#*:}; [ -d ../$n ] || git worktree add -q --detach ../$n $c; (cd ../$n && git checkout -q --detach $c); done
export EXCLUSIVE_OWNER=claude-1833 EXCLUSIVE_TITLE="#1833 bit-field access units" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1833
for n in base merge head; do cd $D/$n && BUSTER_DEBUG_INFO=0 BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; tail -1 build.log; done
echo SETUP DONE
