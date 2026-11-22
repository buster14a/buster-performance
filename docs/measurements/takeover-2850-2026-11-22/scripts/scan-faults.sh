#!/bin/bash
# scan-faults.sh TREE: two single changes to the scan, each built and run against the fixture (test-checker part 45/64),
# which must fail; the tree's file is put back after each.
set -uo pipefail
tree=$1
f=src/buster/compiler/c_check_node_machine_alone.c
cd "$tree"
run()
{
    local name=$1 old=$2 new=$3
    python3 - "$f" "$old" "$new" <<'PY'
import sys
p, old, new = sys.argv[1:4]
s = open(p).read()
assert s.count(old) == 1, (old, s.count(old))
open(p, 'w').write(s.replace(old, new))
PY
    if ./build.sh --config Develop --target compiler > /tmp/claude-1000/lazy/s3/fault-$name-build.log 2>&1; then
        ./build/cmake/native/Develop/compiler test-checker --part 45/64 > /tmp/claude-1000/lazy/s3/fault-$name.txt 2>&1
        echo "$name: test exit $? ($(grep -c 'node-alone' /tmp/claude-1000/lazy/s3/fault-$name.txt) node-alone lines) $(tail -1 /tmp/claude-1000/lazy/s3/fault-$name.txt)"
        grep 'node-alone' /tmp/claude-1000/lazy/s3/fault-$name.txt | grep -o 'the scan finds.*' | head -1
    else
        echo "$name: DID NOT BUILD"; grep -m3 'error' /tmp/claude-1000/lazy/s3/fault-$name-build.log
    fi
    git checkout -q -- "$f"
}
run never "        bool left = kinds[token] == PARSE_KIND_SIZEOF || ((visit & BUSTER_CHECK_EXPRESSION_ACTS) != 0 && code == CHECK_INPUT_CODE_SCALAR);" "        bool left = kinds[token] == PARSE_KIND_SIZEOF && code == 255;"
run reach "            lost = at != token && takes &&
                   (taker == CHECK_INPUT_CODE_TERMINATOR || taker == CHECK_INPUT_CODE_CONDITION || taker == CHECK_INPUT_CODE_RETURN || taker == CHECK_INPUT_CODE_INITIALIZE);" "            lost = true;"
run characters "                left = length > quote + 3;" "                left = false;"
./build.sh --config Develop --target compiler > /tmp/claude-1000/lazy/s3/fault-restore-build.log 2>&1; echo "restored build exit $?"
git status --short | head -3
