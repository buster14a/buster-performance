#!/bin/bash
# Mutants 16, 18 and 19 of bind.c rerun on claude/2924-linker-2's head in /tmp/claude-0/m16, one at a time.
while pgrep -f 'mute/run.sh' > /dev/null || pgrep -f 'mutb/run.sh' > /dev/null; do sleep 30; done
cd /tmp/claude-0/m16
for n in 16 18 19; do
  git checkout -q -- src/buster/compiler/bind.c
  line=$(sed -n "${n}p" /tmp/claude-0/mutb/mutants.txt)
  python3 - "$line" <<'PY' || { echo "mutant $n: NOT APPLIED"; continue; }
import sys
f, old, new = sys.argv[1].split('@@')
p = 'src/buster/compiler/' + f
s = open(p).read(); assert s.count(old) == 1
open(p, 'w').write(s.replace(old, new))
PY
  ./build.sh --config Release > /tmp/claude-0/rerun-b$n.log 2>&1 || { echo "mutant $n: BUILD FAILED"; continue; }
  r=""
  for t in test-bind test-dynamic test-static test-snapshot test-executable; do
    timeout 900 ./build/compiler $t > /tmp/claude-0/rerun-m$n-$t.log 2>&1; e=$?
    r="$r $t:exit=$e,fails=$(grep -cE '[1-9][0-9]* failed' /tmp/claude-0/rerun-m$n-$t.log)"
  done
  echo "mutant $n:$r"
done
git checkout -q -- src/buster/compiler/bind.c
