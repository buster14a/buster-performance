#!/bin/bash
# run6.sh WORKER OF: the base's Debug build and tests in /home/user/mut22/treeWORKER, then its share of the round's
# faults (ROUND in the environment; 1 by default). Worker 0 makes the base's probes' lines before any fault.
w=$1; of=$2; r=${ROUND:-1}; export ROUND=$r
cd /home/user/mut22/tree$w || exit 1
./build.sh --config Debug --jobs 1 > /home/user/mut21/base$r-build-$w.log 2>&1 || { echo "base build failed" > /home/user/mut21/results$r-$w.txt; exit 1; }
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
./build/compiler test-checker --seed 133 --part 5/8 > /home/user/mut21/base$r-part5-$w.out 2> /home/user/mut21/base$r-part5-$w.err
echo "base status $?" >> /home/user/mut21/base$r-part5-$w.out
grep -q "base status 0" /home/user/mut21/base$r-part5-$w.out || { echo "base tests failed" > /home/user/mut21/results$r-$w.txt; exit 1; }
if [ "$w" = 0 ]; then /usr/bin/python3 /home/user/mut21/faults6.py 0 $of base || exit 1; fi
while ! test -s /home/user/mut21/base$r-probes.txt; do sleep 5; done
exec /usr/bin/python3 /home/user/mut21/faults6.py $w $of
