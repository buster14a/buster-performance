#!/bin/bash
# Each mutant on a copy of the tree at HEAD: build Release, run test-debug and test-inflate.
src=/home/user/buster
work=/tmp/claude-0/mut/tree
rm -rf $work; git -C $src worktree remove --force $work 2>/dev/null; git -C $src worktree add -q --detach $work HEAD
n=0
while IFS='|' read -r file old new; do
  n=$((n+1))
  git -C $work checkout -q -- .
  python3 -c "
import sys
p='$work/src/buster/compiler/'+sys.argv[1]; s=open(p).read(); a=sys.argv[2]; b=sys.argv[3].replace('\\\\&','&')
assert s.count(a)==1, 'not unique'
open(p,'w').write(s.replace(a,b))" "$file" "$old" "$new" || { echo "mutant $n: NOT APPLIED"; continue; }
  (cd $work && ./build.sh --config Release > /tmp/claude-0/mut/build$n.log 2>&1) || { echo "mutant $n: BUILD FAILED"; continue; }
  d=$($work/build/compiler test-debug 2>&1 | grep -c FAIL); i=$($work/build/compiler test-inflate 2>&1 | tail -1)
  echo "mutant $n ($file): debug FAILs=$d; $i"
done < /tmp/claude-0/mut/mutants.txt
