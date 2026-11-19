#!/usr/bin/env bash
set -euo pipefail
harness=$1
output=$2
base=$3
head=$4
mkdir -p "$output"
out=$(realpath "$output")
harness=$(realpath "$harness")
export BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_DEBUG_INFO=0 BUSTER_LINKER=auto
paths=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$paths:$PATH" BUSTER_TOOLCHAIN=path
resource=$(clang -print-resource-dir)
test -f "$resource/include/immintrin.h"
export BUSTER_CLANG_RESOURCE_DIR="$resource"
llvm_lib=$(llvm-config --libdir)
export LD_LIBRARY_PATH="$llvm_lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
echo "Buster and Clang resource directory: $BUSTER_CLANG_RESOURCE_DIR"
clang --version
cmake --version
ninja --version
status=0
for revision in base head; do
    target=$base
    if [[ $revision == head ]]; then target=$head; fi
    git checkout --detach "$target"
    test "$(git rev-parse HEAD)" = "$target"
    ./build.sh --config Release --jobs "$(nproc)"
    ./build.sh print-compile-flags --config Release > "$out/$revision.flags"
    sha256sum build/compiler "$out/$revision.flags"
    bash "$harness/verify.sh" build/compiler "$out/$revision-cases" || status=1
    bash "$harness/sample.sh" build/compiler "$out/$revision-samples" 0 || status=1
    clang -std=c17 -O2 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror \
        tests/driver/dependency_rule.c -o "$out/serializer"
    "$out/serializer" --oracle || status=1
done
if test -s "$out/base-cases/complete" && test -s "$out/head-cases/complete" && cmp "$out/base.flags" "$out/head.flags" && diff -qr "$out/base-cases" "$out/head-cases" && diff -qr "$out/base-samples" "$out/head-samples"; then
    echo "Clean base/head: flags, Make bytes, statuses, stdout, and Buster objects are identical."
else
    status=1
fi
# Run the original parts that contain the two dependency sections. The runner tells us how many units
# it deals, independent of K/N. The counts after each section come from the pinned source's tail.
bash tools/clang-server/build.sh "$out/clang-server"
driver=(build/compiler test-checker-driver --executable "$PWD/build/compiler" --in-process --clang-server "$out/clang-server")
"${driver[@]}" --part 1/64 2>&1 | tee "$out/part-calibration.log" || status=1
units=$(sed -nE 's/^checker-driver: part 1 of 64: [0-9]+ of the ([0-9]+) units dealt$/\1/p' "$out/part-calibration.log")
test -n "$units"
for entry in 'check_test_driver_dependencies(&test,' 'driver_compatibility_tests(executable, clang)'; do
    after=$(awk -v entry="$entry" 'index($0,entry) { active=1; next } /check_test_expect\(&test, check_driver_part.taken != 0/ { active=0 } active && /check_test_driver_takes\(\)/ { n++ } END {print n+0}' src/buster/compiler/c_checker_driver_test.c)
    part=$(((units-after-1)%8+1))
    echo "$entry: $units total, $after groups later, running part $part/8"
    "${driver[@]}" --part "$part/8" 2>&1 | tee "$out/driver-$part.log" || status=1
    if [[ $entry == driver_compatibility* ]]; then grep -E '^CC compatibility: [1-9][0-9]* checks, 0 failures$' "$out/driver-$part.log" || status=1; fi
done
for revision in base head; do
    target=$base
    passes=3
    if [[ $revision == head ]]; then target=$head; passes=2; fi
    git checkout --detach "$target"
    git apply "$harness/count.patch"
    ./build.sh --config Release --jobs "$(nproc)"
    ./build.sh print-compile-flags --config Release > "$out/$revision-counted.flags"
    cmp "$out/$revision.flags" "$out/$revision-counted.flags"
    echo "Counted $revision $target"
    sha256sum build/compiler "$harness/count.patch"
    bash "$harness/sample.sh" build/compiler "$out/$revision-counted-samples" "$passes" || status=1
    for file in real.out example.dep example.o stress.out stress_md.dep stress.o; do
        cmp "$out/$revision-samples/$file" "$out/$revision-counted-samples/$file" || status=1
    done
    git restore -- src/buster/compiler/c_dependency.c src/buster/compiler/c_dependency_driver.c
done
echo "Qualification status=$status"
exit "$status"
