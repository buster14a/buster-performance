#!/bin/bash
# base-check.sh: the final sources as the baseline host builds them (BUSTER_HOST_ARCH=x86-64: no AVX-512, the
# intrinsics emulated), a Debug build, then the asks' tests: test-preprocessor's parts 1 and 4 of 4 and test-files.
out=/home/user/keep/base-check
mkdir -p "$out"
cd /home/user/keep/base-tree || exit 1
BUSTER_HOST_ARCH=x86-64 ./build.sh --config Debug > "$out/build.log" 2>&1
echo "baseline Debug build: exit $?" >> "$out/progress.txt"
for test in "test-preprocessor --part 1/4" "test-preprocessor --part 4/4" "test-files"; do
    label=$(echo "$test" | tr ' /' '--')
    ./build/compiler $test > "$out/$label.out" 2> "$out/$label.err"
    echo "$test: exit $?; $(grep -c 'WRONG' "$out/$label.out") WRONG lines; $(grep 'directory asks:\|component keys:\|^asks:' "$out/$label.out" | cut -c1-120 | tr '\n' ';')" >> "$out/progress.txt"
done
echo "done" >> "$out/progress.txt"
