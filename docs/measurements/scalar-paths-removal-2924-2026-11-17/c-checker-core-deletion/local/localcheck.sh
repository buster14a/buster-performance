#!/bin/bash
# The checker core branch's local checks: a build, then tools/ci/correctness.tests' blocks that run a checker test and need
# no corpus (subset.py), and the two that compile main.c, through the parallel runner with the toolchain's clang 23.1.4 first on PATH.
O=/root/.cache/claude-c7/c12k/local; mkdir -p $O; S=$O/status.txt; : > $S
cd /home/user/buster-c12k || exit 1
echo "head $(git rev-parse --short HEAD)" >> $S
./build.sh > $O/build.log 2>&1; echo "build: $?" >> $S
cp build/compiler $O/compiler
python3 - <<'PY'
import re
s = open('tools/ci/correctness.tests').read()
blocks = re.split(r'(?m)^(?=== )', s)
keep = []
heavy = []
for b in blocks[1:]:
    body = '\n'.join(l for l in b.split('\n')[1:] if not l.startswith('#'))
    if re.search(r'test-check|test-checker|--verify', body) and not re.search(r'BUSTER_CORPUS|\$corpus|c-testsuite|sqlite|BUSTER_HOSTED|BUSTER_PRODUCT', body):
        (heavy if 'BUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c' in body else keep).append(b)
open('/root/.cache/claude-c7/c12k/local/subset.tests', 'w').write(blocks[0] + ''.join(keep))
open('/root/.cache/claude-c7/c12k/local/heavy.tests', 'w').write(blocks[0] + ''.join(heavy))
print(len(keep), len(heavy))
PY
T=$(dirname $(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin/clang | head -1))
PATH=$T:$PATH BUSTER_COMPILER=$O/compiler $O/compiler parallel --jobs 3 --timeout 3000 < $O/subset.tests > $O/subset.log 2>&1; echo "subset: $?" >> $S
grep -E '^== .*: (failed|stopped)' $O/subset.log >> $S
# main.c's two checks (5 to 7.5 GiB each) one at a time, after the rest: together with it they would pass the container's 15 GB.
PATH=$T:$PATH BUSTER_COMPILER=$O/compiler $O/compiler parallel --jobs 1 --timeout 3000 < $O/heavy.tests > $O/heavy.log 2>&1; echo "heavy: $?" >> $S
grep -E '^== .*: (failed|stopped)' $O/heavy.log >> $S
echo done >> $S
