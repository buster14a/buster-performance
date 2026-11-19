#!/bin/bash
# The rebased reader branch's local checks, one after another; each line of status.txt is a step and its exit.
cd /home/user/buster-c12c || exit 1
O=/root/.cache/claude-c7/c12c/rebased
S=$O/status.txt
: > $S
parts() { # parts NAME ENV...: test-checker's four parts at once
    local name=$1; shift
    for k in 1 2 3 4; do env "$@" ./build/compiler test-checker --part $k/4 > $O/$name-$k.log 2>&1 & done
    local r=0; for j in $(jobs -p); do wait $j || r=1; done
    echo "$name: $r $(grep -h 'recorded digests' $O/$name-*.log | awk '{a+=$6; b+=$11} END {print a " with a line, " b " without"}') $(grep -h ' failures$' $O/$name-*.log | awk '{f+=$4} END {print f " failures"}')" >> $S
}
parts checker
L=/tmp/claude-0/a-temporary-directory-whose-name-is-much-longer-than-the-default-one-0123456789
mkdir -p $L
parts checker-long-tmpdir TMPDIR=$L
for k in 1 2 3 4; do ./build/compiler test-checker-driver --executable ./build/compiler --part $k/4 > $O/driver-$k.log 2>&1; echo "driver $k: $?" >> $S; done
./build/compiler test-checker-corpus --deferred 8 > $O/corpus.log 2>&1; echo "corpus --deferred 8: $?" >> $S
./build/compiler test-check-units > $O/units.log 2>&1; echo "check-units: $?" >> $S
./build/compiler test-check-lanes > $O/lanes.log 2>&1; echo "check-lanes: $?" >> $S
./build/compiler test-checker-deferred > $O/deferred.log 2>&1; echo "checker-deferred: $?" >> $S
./build/compiler test-call-graph > $O/call-graph.log 2>&1; echo "call-graph: $?" >> $S
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $O/predefines.h 2>/dev/null || $(ls -d /root/.cache/buster/toolchain/*/llvm-*/bin/clang | head -1) -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $O/predefines.h
./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c > $O/complete.log 2>&1; echo "complete driver -fsyntax-only -Wall -Werror: $?" >> $S
./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > $O/self.log 2>&1; echo "self-check: $?" >> $S
echo done >> $S
