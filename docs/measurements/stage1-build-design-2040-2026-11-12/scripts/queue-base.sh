#!/bin/bash
# The scenarios of today's build (main c5f0efb2, ./build.sh as it is: Release, -g, eight jobs), each build its own hold
# of the 9700X's lock. The clean builds first, on the pristine tree; then three rounds of the rebuilds, each of which
# appends another emitted function to its file (run.sh), so every round's edit is new code in every unit that reads it.
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
echo $$ > queue-base.pid
one() { scripts/lock.sh scripts/run.sh "$@"; }
for rep in 1 2 3; do
    one base src clean clean - $rep
done
for rep in 1 2 3; do
    one base src noop none - $rep
    one base src checker append c_check_input.c $rep
    one base src backend append differential.c $rep
    one base src codegen append tier0.c $rep
    one base src frontend append c_parser_impl.c $rep
    one base src test-private append c_checker_driver_test.c $rep
    one base src test-shared append c_checker_test.c $rep
    one base src header guarded host_isa.h $rep
done
(cd src && git diff --stat > "$d/logs/base-edits.diffstat" && git checkout -q -- src)
one base src restore none - 0
echo done >> results/base.txt
