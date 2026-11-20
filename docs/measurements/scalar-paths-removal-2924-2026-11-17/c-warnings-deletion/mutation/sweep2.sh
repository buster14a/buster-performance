#!/bin/bash
# The lane sweep with six units (115333eed) on the unmutated deletion: build, driver part 5; then m11.
cd "$(dirname "$0")"
T=$(dirname $(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin/clang | head -1))
export PATH=$T:$PATH
: > sweep2.txt
(cd tree && timeout -k 5 1800 ./build.sh > ../sweep2-baseline-build.log 2>&1); echo "baseline build: $?" >> sweep2.txt
(cd tree && timeout -k 5 1800 ./build/compiler test-checker-driver --executable ./build/compiler --part 5/8 --in-process > ../sweep2-baseline-driver5.log 2>&1); echo "baseline driver 5: $?" >> sweep2.txt
grep -c 'interrupt sweep' sweep2-baseline-driver5.log >> sweep2.txt
flock -n lock python3 sweep2.py m11 > sweep2.out 2>&1
echo "sweep exit $?" >> sweep2.txt
