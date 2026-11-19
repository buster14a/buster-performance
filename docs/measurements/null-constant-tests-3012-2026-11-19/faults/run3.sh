#!/bin/bash
# run.sh WORKER OF: the base's Debug build and tests in /home/user/mut16/treeWORKER, then its share of the round's
# faults (ROUND in the environment; 1 by default).
w=$1; of=$2; r=3
cd /home/user/mut16/tree$w || exit 1
./build.sh --config Debug --jobs 1 > /home/user/mut17/base$r-build-$w.log 2>&1 || { echo "base build failed" > /home/user/mut17/results$r-$w.txt; exit 1; }
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
./build/compiler test-checker --seed 133 --part 5/8 > /home/user/mut17/base$r-part5-$w.out 2> /home/user/mut17/base$r-part5-$w.err
echo "base status $?" >> /home/user/mut17/base$r-part5-$w.out
grep -q "base status 0" /home/user/mut17/base$r-part5-$w.out || { echo "base tests failed" > /home/user/mut17/results$r-$w.txt; exit 1; }
exec /usr/bin/python3 /home/user/mut17/faults3.py $w $of
