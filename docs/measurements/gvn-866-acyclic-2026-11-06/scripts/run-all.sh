#!/bin/bash
# Waits for build-both.sh (the candidate's build) to finish, then runs every A/B step of ab.sh.
cd "$HOME/buster-fast-bench/866-claude" || exit 1
while pgrep -f '[b]uild-both.sh' > /dev/null; do sleep 20; done
grep -q 'published as build/compiler' build-cand.log || { echo "run-all: the candidate's build failed"; exit 1; }
./scripts/ab.sh shifts synthetic source tier1 perf
