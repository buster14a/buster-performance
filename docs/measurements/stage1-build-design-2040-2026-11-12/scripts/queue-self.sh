#!/bin/bash
# The compiler built by itself (selfbuild.sh), after the queue named by $1 ends, each step its own hold of the lock:
# every unit by stage 1 at the default tier and at Tier 1, eight at once and one at a time; the three largest units
# alone, as an edit of one would compile it; stage 2's link; the hybrid, the checker's unit compiled by stage 1 and
# the others by clang; their speed on sqlite3.c's -c; and the tests' list by each.
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
echo $$ > queue-self.pid
while kill -0 "$(cat "${1:-queue-variants}.pid" 2>/dev/null)" 2>/dev/null; do sleep 5; done
lock() { scripts/lock.sh "$@"; }
lock scripts/selfbuild.sh compile t0 1
lock scripts/selfbuild.sh compile t0 8
for unit in main_unit_checker main_unit_backend main_unit_frontend; do
    lock scripts/selfbuild.sh unit t0 $unit default
    lock scripts/selfbuild.sh unit t0 $unit 1
done
lock scripts/selfbuild.sh link t0
lock scripts/selfbuild.sh hybrid t0 main_unit_checker
lock scripts/selfbuild.sh compile t1 1
lock scripts/selfbuild.sh compile t1 8
lock scripts/selfbuild.sh unit t1 main_unit_checker default
lock scripts/selfbuild.sh link t1
lock scripts/selfbuild.sh hybrid t1 main_unit_checker
lock scripts/selfbuild.sh speed stage2-t0 stage2-t1 hybrid-main_unit_checker-t0 hybrid-main_unit_checker-t1
lock scripts/tests.sh release "$d/src/build/compiler"
lock scripts/tests.sh hybrid-checker-t0 "$d/scratch/self/hybrid-main_unit_checker-t0"
echo done >> results/self/links.txt
