#!/usr/bin/env bash
# m8 again (the old runner stopped it at the oracle's retained-files line of a known fpclassify failure), after all4.sh's.
cd "$(dirname "$0")"
while pgrep -f "bash ./all2.sh" > /dev/null || pgrep -f "bash ./all3.sh" > /dev/null || pgrep -f "bash ./all4.sh" > /dev/null; do sleep 30; done
./run_mutant.sh m8_vla_unpadded "test-checker"
echo "all5 done $(date -Is)"
