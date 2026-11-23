#!/bin/sh
# benchpress's disk is full (2026-11-22): each tree builds in tmpfs, keeps build/compiler on disk, drops its build tree.
D=/tmp/c1341/w; T=/tmp/c1341; cd $D; mkdir -p bin
export EXCLUSIVE_OWNER=claude-1341-1379-1387 EXCLUSIVE_TITLE="9700X acceptance: #1341 #1379 #1387" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngFHzyrnWayfMuSLbk
for t in "$@"; do
  n=${t%%:*}; c=${t#*:}
  if [ -x bin/$n ]; then echo "$n already built"; continue; fi
  [ -d $T/$n ] || git -C repo worktree add -q --detach $T/$n $c
  [ $n = fld1 ] && git -C $T/$n apply $D/fld1.patch
  x=""; [ $n = fld1 ] && x="BUSTER_DEBUG_INFO=0"
  (cd $T/$n && env $x ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > $D/build-$n.log 2>&1) && cp -L $T/$n/build/compiler bin/$n && echo "$n built $(date -u +%T) $(du -sh $T/$n/build | cut -f1)" || { echo "$n BUILD FAILED"; grep -E "error|FAILED" $D/build-$n.log | head -5; }
  rm -rf $T/$n/build
done
echo "BUILDS DONE"; df -h / /tmp | tail -2
