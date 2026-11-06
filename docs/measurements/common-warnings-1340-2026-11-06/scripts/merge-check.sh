#!/bin/bash
# merge-check.sh: the branch merged with origin/main (a local, unpushed merge commit), built and run through the checker suites.
set -u
D=/home/david/.cache/droid-1340
W=$D/wt-merge
out=$D/tests-merge
mkdir -p "$out"
rm -f "$out/summary"
cd "$W" || exit 2
./build.sh > "$out/build.log" 2>&1 || { echo "build exit $?" >> "$out/summary"; exit 1; }
run() { local name=$1; shift; "$@" > "$out/$name.log" 2>&1; echo "$name exit $?" >> "$out/summary"; }
export -f run
export out
printf '%s\n' \
  "driver1 ./build/compiler test-checker-driver --executable ./build/compiler --part 1/4" \
  "driver2 ./build/compiler test-checker-driver --executable ./build/compiler --part 2/4" \
  "driver3 ./build/compiler test-checker-driver --executable ./build/compiler --part 3/4" \
  "driver4 ./build/compiler test-checker-driver --executable ./build/compiler --part 4/4" \
  "lazy1 ./build/compiler test-checker-driver --executable ./build/compiler --lazy-system-headers --part 1/2" \
  "lazy2 ./build/compiler test-checker-driver --executable ./build/compiler --lazy-system-headers --part 2/2" \
  "checker ./build/compiler test-checker --seed 133" \
  "deferred ./build/compiler test-checker-deferred" \
  | xargs -P "${CORES:-4}" -L1 bash -c 'run "$@"' _
echo all-done >> "$out/summary"
