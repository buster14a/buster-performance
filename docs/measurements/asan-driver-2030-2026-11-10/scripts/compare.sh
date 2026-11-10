#!/bin/bash
# test-checker-driver --part 1/16 under CI's options for each compiler: the variants' multipliers and the branch's
# fixed-address build, in one series on one core (cores -n 1), each result a line of driver.txt.
set -u
D=$HOME/.cache/claude-pr2056-review/2030
"$D/driver.sh" r2-asan "$D/compiler-asan" 1/16
"$D/driver.sh" r2-asan-only "$D/compiler-asan-only" 1/16
"$D/driver.sh" r2-asan-ubsan "$D/compiler-asan-ubsan" 1/16
"$D/driver.sh" r2-uar-runtime-on "$D/compiler-uar-runtime" 1/16
"$D/driver.sh" r2-uar-runtime-off "$D/compiler-uar-runtime" 1/16 detect_stack_use_after_return=0
"$D/driver.sh" r2-fixed "$D/compiler-fixed" 1/16
"$D/driver.sh" r2-nothp-asan "$D/compiler-asan" 1/16 "" "" nothp
"$D/driver.sh" r2-fixed-nothp "$D/compiler-fixed" 1/16 "" "" nothp
"$D/driver.sh" r2-plain "$D/compiler-plain" 1/16
