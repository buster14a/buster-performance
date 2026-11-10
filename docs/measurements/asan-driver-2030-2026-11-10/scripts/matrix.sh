#!/bin/bash
# One variable at a time on test-checker-driver --part 1/16 under the fused address row, CI's options otherwise.
D=$HOME/.cache/claude-pr2056-review/2030
C=$D/compiler-asan
$D/driver.sh asan-noleaks "$C" 1/16 detect_leaks=0
$D/driver.sh asan-noglobals "$C" 1/16 "" use_globals=0
$D/driver.sh asan-nostrict "$C" 1/16 strict_string_checks=0
$D/driver.sh asan-noinitorder "$C" 1/16 check_initialization_order=0
$D/driver.sh asan-again "$C" 1/16
