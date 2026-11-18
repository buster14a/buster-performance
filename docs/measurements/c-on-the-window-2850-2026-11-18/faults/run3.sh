#!/bin/bash
# run2.sh WORKER OF: the base's Debug build and tests in /home/user/mut15/treeWORKER, then its share of the third
# round's faults.
w=$1; of=$2
cd /home/user/mut15/tree$w || exit 1
./build.sh --config Debug --jobs 1 > /home/user/mut15/base3-build-$w.log 2>&1 || { echo "base build failed" > /home/user/mut15/results3-$w.txt; exit 1; }
./build/compiler test-checker --seed 133 --part 5/8 > /home/user/mut15/base3-part5-$w.out 2> /home/user/mut15/base3-part5-$w.err
echo "base status $?" >> /home/user/mut15/base3-part5-$w.out
grep -q "base status 0" /home/user/mut15/base3-part5-$w.out || { echo "base tests failed" > /home/user/mut15/results3-$w.txt; exit 1; }
exec /usr/bin/python3 /home/user/mut15/faults3.py $w $of
