#!/bin/bash
# One failing inventory command again, on Develop's executable and on a Release one, in `ci` (buster#2559).
set -u
d=$HOME/buster-fast-bench/2559-claude
cd "$d/ci"
while IFS= read -r line; do export "$line"; done < "$d/ci.env"
while IFS= read -r line; do PATH="$line:$PATH"; done < "$d/ci.path"
export PATH BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_ORACLE_CACHE=use
develop=$(./build.sh print-output --config Develop)
for compiler in "$develop" "$d/src/build/cmake/native/Release/compiler"; do
    echo "== $compiler"
    "$compiler" test-preprocessor --compare-clang --clang clang -nostdinc --files-from tests/preprocessor-oracle/inputs.txt --root tests/preprocessor-oracle --report /tmp/repro-2559.tsv 2>&1 | tail -4
    echo "status ${PIPESTATUS[0]}"
done
