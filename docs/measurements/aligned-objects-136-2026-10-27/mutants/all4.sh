#!/usr/bin/env bash
# m7 again (its first tree left the realignment check unused, which -Werror refuses), after all3.sh's.
cd "$(dirname "$0")"
while pgrep -f "bash ./all.sh" > /dev/null || pgrep -f "bash ./all2.sh" > /dev/null || pgrep -f "bash ./all3.sh" > /dev/null; do sleep 30; done
./run_mutant.sh m7_unwind_unchecked "test-unwind"
echo "all4 done $(date -Is)"
