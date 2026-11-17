#!/bin/bash
# #1590's main-vs-head measurement on the 9700X: mixed source links (a positional object beside the C) and a direct
# control, whole drivers under time-runs, each round one lock hold.
set -u
W=$HOME/buster-fast-bench/1590-claude
BASE_SHA=$1
HEAD_SHA=$2
LOCK=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1590 EXCLUSIVE_TITLE="Foreign linker: library versions in mixed links (#1590)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1590
cd $W
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo || exit 1
git -C repo fetch -q origin main claude/admiring-euler-rqqw7j || exit 1
for t in base head; do
  sha=$BASE_SHA; [ $t = head ] && sha=$HEAD_SHA
  [ -d $t ] || git -C repo worktree add -q --detach ../$t $sha || exit 1
  [ "$(git -C $t rev-parse HEAD)" = "$sha" ] || { echo "$t is not at $sha"; exit 1; }
  if [ ! -x $t/build/compiler ]; then
    $LOCK env BUSTER_DEBUG_INFO=0 bash -c "cd $W/$t && ./build.sh --config Release" > build-$t.log 2>&1 || { echo "build $t failed"; tail -5 build-$t.log; exit 1; }
  fi
  cp $t/build/compiler compiler-$t
done
mkdir -p inputs
cat > inputs/hello.c <<'C'
#include <stdio.h>
#include <math.h>
int extra_value(void);
int main(int argc, char** argv) { (void)argv; printf("%d %f\n", extra_value(), sqrt((double)argc + 1.0)); return 0; }
C
cat > inputs/extra.c <<'C'
int extra_value(void) { return 42; }
C
clang -c -O2 -o inputs/extra.o inputs/extra.c || exit 1
cp inputs/hello.c inputs/direct.c
sed -i 's/int extra_value(void);/static int extra_value(void) { return 42; }/' inputs/direct.c
for list in "inputs/hello.c inputs/extra.o -lm" "inputs/direct.c -lm"; do
  for t in base head; do
    ./compiler-$t -o /dev/shm/1590-out-$t $list > /dev/null 2>&1 && /dev/shm/1590-out-$t > /dev/null || { echo "$t: $list doesn't link and run"; exit 1; }
  done
  if cmp -s /dev/shm/1590-out-base /dev/shm/1590-out-head; then echo "$list: base and head write the same bytes"; else echo "$list: base and head outputs differ"; fi
done
rm -f /dev/shm/1590-out-base /dev/shm/1590-out-head
B="--build base $W/compiler-base --build head $W/compiler-head --build base-again $W/compiler-base"
for round in 1 2 3; do
  echo "== round $round"
  (cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6) 2>&1
  $LOCK taskset -c 2 ./compiler-head time-runs --runs 5 --copies 3 --directory /dev/shm $B \
      --list -o /dev/shm/1590-mixed inputs/hello.c inputs/extra.o -lm \
      --list -o /dev/shm/1590-direct inputs/direct.c -lm 2>&1
  (cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6) 2>&1
done
rm -f /dev/shm/1590-mixed /dev/shm/1590-direct
echo done
