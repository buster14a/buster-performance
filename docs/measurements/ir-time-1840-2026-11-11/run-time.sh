#!/bin/bash
# buster#1840 item 8 (package B3): main against the B3 stack's head (ir/1840-aes), each built by build.sh (znver5), each
# then self-built by its own --tier1 at -march=znver5 (every unit; one hold of the lock for the whole self-build, its
# units compiled 8 at a time), and the self-built compilers' --time-stages of -fsyntax-only main.c, --lanes 1, pinned to
# CPU 2, 11 rounds alternating which goes first, one hold per run.
set -u
D=~/buster-fast-bench/1840-claude-b3/time
mkdir -p $D && cd $D
export EXCLUSIVE_OWNER=claude-b3-1840 EXCLUSIVE_TITLE="B3 #1840 self-built Tier 1 stage timings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
[ -d repo ] || git clone -q https://github.com/buster14a/buster repo
git -C repo fetch -q origin main ir/1840-aes
BASE=$(git -C repo rev-parse origin/main)
HEAD=$(git -C repo rev-parse origin/ir/1840-aes)
echo "base $BASE head $HEAD" > commits.txt
for t in base head; do
  c=$BASE; [ $t = head ] && c=$HEAD
  [ -d $t ] || git -C repo worktree add -q --detach ../$t $c
  git -C $t checkout -q --detach $c
  $X sh -c "cd $t && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh" > build-$t.log 2>&1
  echo "build $t exit $?" >> log.txt
done
: <<'INNER'
#!/bin/bash
# $1: the tree; its compiler builds every unit by --tier1, 8 at a time, then clang links them.
t=$1
D=$(pwd)
FLAGS="-march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-pc-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1"
rm -rf self-$t && mkdir -p self-$t
(cd $t && ./build.sh print-sources) | tr '\0' '\n' | grep . > self-$t/sources.txt
start=$(date +%s.%N)
xargs -P 8 -I{} sh -c 'b=$(basename {} .c); cd '"$t"' && eval ./build/compiler -c --tier1 --tier1-report '"$FLAGS"' -o '"$D"'/self-'"$t"'/$b.o {} > '"$D"'/self-'"$t"'/$b.report 2>&1 || echo "self '"$t"' {} FAILED"' < self-$t/sources.txt
end=$(date +%s.%N)
echo "self-build $t: $(wc -l < self-$t/sources.txt) units in $(echo "$end - $start" | bc) s, 8 at a time"
clang -no-pie -o self-$t/compiler self-$t/*.o -lm -ldl -lpthread && echo "self $t linked"
INNER
chmod +x selfbuild.sh
for t in base head; do
  $X ./selfbuild.sh $t >> log.txt 2>&1
done
cd $D/base
clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > $D/predefines.h
mkdir -p $D/stages
for r in $(seq 1 11); do
  order="base head"; [ $((r % 2)) = 0 ] && order="head base"
  for t in $order; do
    $X taskset -c 2 $D/self-$t/compiler -fsyntax-only --time-stages --lanes 1 -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c > $D/stages/$t-$r.txt 2>&1
  done
done
cd $D
echo "stages done" >> log.txt
touch done
