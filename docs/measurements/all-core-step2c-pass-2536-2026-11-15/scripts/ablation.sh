#!/bin/bash
# ablation.sh: the experiment commit in variant.bundle (the PR's head with BUSTER_PASS_VARIANT switches, never pushed)
# built at Release under the lock; then, in one hold, sqlite3.c's and main.c's --selection-census by main's build
# (compiler-base) and by the experiment's under each variant, 7 rounds, the order rotated each round, on CPU 2.
# Variants: 0 all parts on; 1 no chunk marking; 2 no leaf fast path; 4 no prune filter; 8 the fast path from 3 leaves.
set -u
cd ~/buster-fast-bench/2536-step2c-claude
export EXCLUSIVE_OWNER=claude-2536-step2c EXCLUSIVE_TITLE="Problem 2536 (step 2.2c pass ablation)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2816
repo=~/buster-fast-bench/2536-step1-claude/repo
git -C "$repo" fetch -q origin main
git -C "$repo" fetch -q "$PWD/variant.bundle" +HEAD:refs/heads/variant-2536-step2c
commit=$(git -C "$repo" rev-parse variant-2536-step2c)
[ -d variant ] || git -C "$repo" worktree add --detach "$PWD/variant" "$commit"
git -C variant checkout -q --detach "$commit"
echo "$commit" > COMMIT.variant
(cd variant && ~/buster-fast-bench/exclusive.sh timeout 1800 ./build.sh --config Release) > build.variant.log 2>&1
echo "build status $?" >> build.variant.log
cp variant/build/compiler compiler-variant
sha256sum compiler-variant >> build.variant.log
mkdir -p ablation
~/buster-fast-bench/exclusive.sh timeout 900 ./ablation-runs.sh >> ablation/holds.log 2>&1
echo "ablation status $?" >> ablation/holds.log
echo done >> ablation/holds.log
