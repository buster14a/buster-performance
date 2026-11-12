#!/bin/bash
# buster#2559's gates on the 9700X, one lock hold a line (lock.sh), in order; each line's start, end and status go to
# results/queue.txt. Run detached: setsid nohup ./queue.sh > queue.log 2>&1 < /dev/null &
set -u
d=$HOME/buster-fast-bench/2559-claude
s=$d/scripts
L=$s/lock.sh
R=$s/run.sh
release=$d/src/build/cmake/native/Release/compiler
develop=$d/src/build/cmake/native/Develop/compiler
mkdir -p "$d/results" "$d/logs"
echo $$ > "$d/queue.pid"
step() {
    local start=$(date -u +%FT%TZ)
    "$L" "$@"
    local rc=$?
    printf '%s\t%s\trc=%s\t%s\n' "$start" "$(date -u +%FT%TZ)" "$rc" "$*" >> "$d/results/queue.txt"
}
step "$R" develop src clean clean - 1 --config Develop
step "$R" develop src nothing none - 1 --config Develop
step "$R" develop src checker append c_check_input.c 1 --config Develop
step "$R" develop src checker append c_check_input.c 2 --config Develop
step "$R" develop src checker append c_check_input.c 3 --config Develop
step "$R" develop src checker-top prepend c_check_input.c 1 --config Develop
step "$R" develop src differential append differential.c 1 --config Develop
step "$R" develop src tier0 append tier0.c 1 --config Develop
step "$R" develop src frontend append c_parser_impl.c 1 --config Develop
step "$R" develop src driver-test append c_checker_driver_test.c 1 --config Develop
step "$R" develop src checker-test append c_checker_test.c 1 --config Develop
step "$R" develop src header guarded host_isa.h 1 --config Develop
step "$R" develop src header-touch touch host_isa.h 1 --config Develop
step "$R" develop src nothing none - 2 --config Develop
step "$R" develop src clean-after-edits clean - 1 --config Develop
step "$R" develop src restore restore - 1 --config Develop
step "$R" develop src clean clean - 2 --config Develop
step "$R" develop src clean clean - 3 --config Develop
step "$R" release src clean cleanconfig - 1 --config Release
step "$R" release src nothing none - 1 --config Release
step "$R" release src checker append c_check_input.c 1 --config Release
step "$R" release src restore restore - 1 --config Release
step "$R" develop src restore restore - 2 --config Develop
step "$s/objects.sh"
step "$s/tests.sh" release "$release"
step "$s/tests.sh" develop "$develop"
step "$s/tests.sh" release-2 "$release"
step "$s/tests.sh" develop-2 "$develop"
step "$s/config-speed.sh" sqlite 7 "develop=$develop"
step "$s/config-speed.sh" syntax 5 "develop=$develop"
echo done >> "$d/results/queue.txt"
