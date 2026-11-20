#!/bin/bash
# The lane sweep (e329788bf) on the unmutated deletion: build, driver part 5 (the interrupt units); then m11 and m14.
cd "$(dirname "$0")"
T=$(dirname $(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin/clang | head -1))
export PATH=$T:$PATH
: > sweep.txt
(cd tree && timeout -k 5 1800 ./build.sh > ../sweep-baseline-build.log 2>&1); echo "baseline build: $?" >> sweep.txt
(cd tree && timeout -k 5 1800 ./build/compiler test-checker-driver --executable ./build/compiler --part 5/8 --in-process > ../sweep-baseline-driver5.log 2>&1); echo "baseline driver 5: $?" >> sweep.txt
grep -c 'interrupt sweep' sweep-baseline-driver5.log >> sweep.txt
flock -n lock python3 sweep.py m11 m14 > sweep.out 2>&1
echo "sweep exit $?" >> sweep.txt
