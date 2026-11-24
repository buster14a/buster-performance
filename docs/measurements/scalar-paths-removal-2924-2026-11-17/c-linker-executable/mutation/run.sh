#!/bin/bash
# Each mutant of bind.c on a worktree at HEAD: build Release, run the binding tests.
src=/home/user/buster
work=/tmp/claude-0/mute/tree
[ -d $work ] || git -C $src worktree add -q --detach $work claude/2924-linker-3
n=0; start=${START:-1}
while IFS= read -r line; do
  n=$((n+1)); [ $n -lt $start ] && continue
  git -C $work checkout -q -- .
  python3 - "$work" "$line" <<'PY' || { echo "mutant $n: NOT APPLIED"; continue; }
import sys
work, line = sys.argv[1], sys.argv[2]
f, old, new = line.split('@@')
p = work + '/src/buster/compiler/' + f
s = open(p).read()
assert s.count(old) == 1
open(p, 'w').write(s.replace(old, new))
PY
  (cd $work && ./build.sh --config Release > /tmp/claude-0/mute/build$n.log 2>&1) || { echo "mutant $n: BUILD FAILED"; continue; }
  r=""
  for t in test-executable test-dynamic test-static test-snapshot test-debug test-foreign; do
    timeout 900 $work/build/compiler $t > /tmp/claude-0/mute/m$n-$t.log 2>&1; e=$?
    f=$(grep -cE '[1-9][0-9]* failed|FAIL' /tmp/claude-0/mute/m$n-$t.log)
    r="$r $t:exit=$e,fails=$f"
  done
  echo "mutant $n:$r"
done < /tmp/claude-0/mute/mutants.txt
