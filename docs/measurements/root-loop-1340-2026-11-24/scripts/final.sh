#!/bin/bash
# The final tree's local checks: Release build, the focused section, the ownership check, the driver's parts and the
# checker; then the UBSan build with the focused section and sqlite3.c both ways.
cd /home/user/buster || exit 1
L=/home/user/logs/final; rm -rf $L; mkdir -p $L
./build.sh --config Release > $L/build.log 2>&1; echo "exit $?" >> $L/build.log
cp build/compiler /home/user/bin/compiler-final
C=/home/user/bin/compiler-final
$C test-checker-driver --executable $C --quiet-roots-only --in-process > $L/quiet-roots.log 2>&1; echo "exit $?" >> $L/quiet-roots.log
cc -std=c17 -O2 -Wall -Wextra -Werror -o build/build-regression tools/ci/build_regression.c && build/build-regression --ownership-only ./build/compiler > $L/ownership.log 2>&1; echo "exit $?" >> $L/ownership.log
echo first > $L/first
for k in 1 2 3 4; do ($C test-checker-driver --executable $C --part $k/4 --in-process > $L/driver-$k.log 2>&1; echo "exit $?" >> $L/driver-$k.log) & done; wait
$C test-checker --seed 133 > $L/checker.log 2>&1; echo "exit $?" >> $L/checker.log
./build.sh check-call-graph --config Release > $L/call-graph.log 2>&1; echo "exit $?" >> $L/call-graph.log
bash /home/user/bench/blocks.sh > /dev/null 2>&1
BUSTER_SANITIZER=undefined ./build.sh --config Release > $L/ubsan-build.log 2>&1; echo "exit $?" >> $L/ubsan-build.log
cp build/compiler /home/user/bin/compiler-ubsan
U=/home/user/bin/compiler-ubsan
$U test-checker-driver --executable $U --quiet-roots-only --in-process > $L/ubsan-quiet-roots.log 2>&1; echo "exit $?" >> $L/ubsan-quiet-roots.log
cp $C build/compiler
echo done > $L/complete
