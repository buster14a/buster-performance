#!/bin/bash
# job-faults1.sh: single faults of the bodies' comparisons against their fixtures (the branch at 65a97f416, Develop), each
# built and run against test-checker part 45/64, under the lock: the two reworded ones of the walk for a statement no
# control reaches, the entries' builder's sixteen and the eleven beside the entries.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
git -C src fetch -q origin
tree="$dir/trees/faults-65a97f416"
[[ -d "$tree" ]] || git -C src worktree add -q --detach "$tree" 65a97f416
out="$dir/results/faults-65a97f416"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: single faults of the bodies' comparisons against their fixtures" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" bash -c "cd '$tree' && ./build.sh --config Develop --target compiler > '$out/build.log' 2>&1; echo first build \$?; ./build/cmake/native/Develop/compiler test-checker --part 45/64 2>&1 | tail -1; for s in reach-faults-two bodies-faults beside-faults; do python3 '$dir/faults/'\$s.py '$tree' > '$out/'\$s.txt 2>&1; echo \"\$s: \$(tail -1 '$out/'\$s.txt)\"; done" > "$out/summary.txt" 2>&1
echo job-complete
