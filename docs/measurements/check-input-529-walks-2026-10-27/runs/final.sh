#!/bin/bash
# The final comparison in two holds of the lock: main2's and head4's builds in one; then head4's objects against
# main2's, its checker tests, perf stat rounds with the reader's benchmark, and measure-compile both ways in the other.
# The scripts each take the lock themselves; under a holder their nested takes just run.
cd ~/buster-fast-bench/check-input-529b
echo $$ > final.pid
./lock.sh bash -c './build.sh main2 && ./build.sh head4'
mkdir -p head4/build && cp -r head1/build/c-testsuite head4/build/
./lock.sh bash -c './check2.sh head4 check-head4 main2; ./tests.sh head4 checker-tests.list tests-head4; ./measure.sh main2 head4 m-head4; ./stages.sh main2 head4 s-head4'
echo "final done"
