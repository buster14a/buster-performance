#!/usr/bin/env bash
# m10 again (its first run was stopped while the runner was rewritten), after all2.sh's mutants.
cd "$(dirname "$0")"
while pgrep -f "bash ./all.sh" > /dev/null || pgrep -f "bash ./all2.sh" > /dev/null; do sleep 30; done
./run_mutant.sh m10_r15_not_saved "test-tier0" "test-unwind"
echo "all3 done $(date -Is)"
