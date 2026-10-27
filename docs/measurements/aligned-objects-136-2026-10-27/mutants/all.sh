#!/usr/bin/env bash
# The mutants, one after another, each with the suites that must catch it.
cd "$(dirname "$0")"
./run_mutant.sh m1_and_16 "test-tier0"
./run_mutant.sh m2_incoming_rsp "test-tier0" "test-tier0-variadic-frame"
./run_mutant.sh m3_no_base "test-tier0"
./run_mutant.sh m4_alloca_16 "test-tier0"
./run_mutant.sh m9_depths_unrealigned "test-tier0"
./run_mutant.sh m10_r15_not_saved "test-tier0" "test-unwind"
./run_mutant.sh m7_unwind_unchecked "test-unwind"
./run_mutant.sh m5_calls_ignored "test-tier0" "test-checker"
./run_mutant.sh m6_in_place_any "test-checker" "test-tier0"
./run_mutant.sh m8_vla_unpadded "test-checker"
echo "all done $(date -Is)"
