#!/usr/bin/env bash
# The vector twin's mutants (tier0_frame_alignment_vector), after all.sh's.
cd "$(dirname "$0")"
while pgrep -f "bash ./all.sh" > /dev/null; do sleep 30; done
./run_mutant.sh m11_vector_call_bytes "test-tier0"
./run_mutant.sh m12_vector_tail "test-tier0"
./run_mutant.sh m13_vector_objects "test-tier0"
./run_mutant.sh m14_vector_calls_ignored "test-checker" "test-tier0"
echo "all2 done $(date -Is)"
