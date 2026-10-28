#!/bin/bash
# solve #153 (claude/solve-153-049a9d): the merge-base ba379033 against the head, each run under the 9700X's lock.
set -u
cd ~/buster-fast-bench/solve-153-claude
export EXCLUSIVE_OWNER=solve-153-claude
export EXCLUSIVE_TITLE="solve #153: the ids in another order (main vs head)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/153
L=~/buster-fast-bench/exclusive.sh
Q=~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c
log() { echo "$(date +%T) $*" >> status2.log; }
log start
for t in base2 head2; do
    (cd $t && BUSTER_DEBUG_INFO=0 $L taskset -c 0-7 ./build.sh > ../build-$t.log 2>&1); log "build $t $?"
done
for t in base2 head2; do
    $L taskset -c 2 $t/build/compiler -c $Q -o drive-$t.o 2> drive-$t.err; log "drive $t $? $(stat -c %s drive-$t.o 2>/dev/null)"
done
cmp -s drive-base2.o drive-head2.o && log "objects same" || log "objects differ"
rm -rf copies; mkdir -p copies
$L taskset -c 2 head2/build/compiler time-runs --runs 21 --warmups 2 --copies 3 --directory copies --build main base2/build/compiler --build head head2/build/compiler --list -c $Q -o timed.o > time-runs2.log 2>&1
log "time-runs $?"
for round in 1 2; do
    for t in base2 head2; do
        order=""
        [ $t = head2 ] && order="--id-order 153"
        timed() { # NAME COMMAND...: the command in $t's tree under the lock, its times appended to times2.log
            local name=$1; shift
            (cd $t && $L bash -c 'TIMEFORMAT="$0 %R s wall %U user %S sys"; time "$@" > /dev/null 2>&1' "$t $name" "$@" 2>> ../times2.log)
        }
        timed test-check-lanes taskset -c 0-7 ./build/compiler test-check-lanes; log "test-check-lanes $t $round $?"
        timed test-checker-deferred taskset -c 0-7 ./build/compiler test-checker-deferred; log "test-checker-deferred $t $round $?"
        timed test-c-testsuite taskset -c 0-3 ./build/compiler test-c-testsuite --jobs 4 --subset tests/c-testsuite/subset.txt ../c-testsuite; log "test-c-testsuite $t $round $?"
        timed test-checker-corpus taskset -c 0-7 env -u CPATH -u C_INCLUDE_PATH ./build/compiler test-checker-corpus --clang clang --deferred 8 $order ../c-testsuite/tests/single-exec; log "test-checker-corpus $t $round $?"
    done
done
log done
