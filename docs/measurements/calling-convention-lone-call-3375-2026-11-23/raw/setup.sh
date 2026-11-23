#!/bin/bash
# #3375: trees for the A/B. old = main 1b9821afe (the per-call scalar code) with main's benchmark file;
# main = c7809112 (abi_assign_lanes, eight calls at a time); headN = main + headN.patch.
set -e
D=~/buster-fast-bench/3375-claude
cd $D
MAIN=c7809112
[ -d repo ] || git clone -q https://github.com/buster14a/buster repo
git -C repo fetch -q origin main
L="EXCLUSIVE_OWNER=claude-3375 EXCLUSIVE_TITLE=issue-3375-calling-convention-kernel EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3375"
for t in "$@"; do
  [ -d $t ] || git -C repo worktree add -q --detach ../$t $MAIN
  case $t in
    old)
      git -C old checkout -q -f 1b9821afe448258d08f47f6110922478aa0e4121
      git -C repo show $MAIN:src/buster/compiler/calling_convention_benchmark.c > old/src/buster/compiler/calling_convention_benchmark.c ;;
    main)
      git -C main checkout -q -f $MAIN ;;
    head*)
      git -C $t checkout -q -f $MAIN
      git -C $t apply $D/$t.patch ;;
  esac
  echo "$t $(git -C $t rev-parse HEAD) $(git -C $t diff | sha256sum | cut -c1-16)" >> commits.txt
  (cd $t && env $L ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > build-$t.log 2>&1
  echo "build $t exit $?" >> build-$t.log
done
echo done > setup-done-$(echo "$@" | tr ' ' '-')
