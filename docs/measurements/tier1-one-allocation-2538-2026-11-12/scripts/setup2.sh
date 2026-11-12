#!/bin/bash
# setup2.sh: round 2's executables (no lock: no build, no run). Copies main's and step 2's placed executables into bins/,
# then frees the disk the host lacks: the step 1 tree and main's build. Fetches the branch's step 4 and step 3 commits.
set -eu
cd "$(dirname "$0")"
mkdir -p bins
for s in 0 1088 2176 3264; do
    cp shifts/main/compiler-$s bins/main-$s
    cp shifts/head/compiler-$s bins/step2-$s
done
sha256sum bins/* > bins.sha256
rm -rf step1 main/build shifts/step1 shifts/main
git -C repo worktree prune
git -C repo fetch -q ../buster2.bundle "refs/heads/claude/zen-shannon-ch4f8b:refs/heads/measured2"
git -C repo rev-parse measured2
df -h . | tail -1
