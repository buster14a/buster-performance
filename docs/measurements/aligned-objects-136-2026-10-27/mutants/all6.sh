#!/usr/bin/env bash
# m12 and m13 again (their first trees left a variable unused, which -Werror refuses), after all5.sh's.
cd "$(dirname "$0")"
while pgrep -f "bash ./all2.sh" > /dev/null || pgrep -f "bash ./all3.sh" > /dev/null || pgrep -f "bash ./all4.sh" > /dev/null || pgrep -f "bash ./all5.sh" > /dev/null; do sleep 30; done
./run_mutant.sh m12_vector_tail "test-tier0"
./run_mutant.sh m13_vector_objects "test-tier0"
echo "all6 done $(date -Is)"
