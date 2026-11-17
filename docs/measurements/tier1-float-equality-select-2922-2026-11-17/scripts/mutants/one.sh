#!/bin/bash
# one.sh TREE N: mutant N of mutants.py alone in TREE (a copy of the tree): build the copy, apply, build, test, revert.
set -u
cd "$1"
nice -n 10 ./build.sh > build0.log 2>&1 || exit 1
here=$(cd "$(dirname "$0")" && pwd)
python3 $here/mutants.py apply $2
nice -n 10 ./build.sh > mutant-build.log 2>&1 || { echo "build failed"; exit 1; }
r=$(timeout 600 ./build/compiler test-tier1-select > mutant-select.log 2>&1; echo $?)
echo "$(python3 $here/mutants.py names | sed -n "$(($2 + 1))p"): select=$r $([ $r = 0 ] && echo SURVIVED || echo killed)"
python3 $here/mutants.py revert $2 > /dev/null
