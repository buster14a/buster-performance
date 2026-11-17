#!/bin/bash
M=/tmp/claude-0/-home-user/6e7265f8-11c8-5a94-9c81-5c376796b20a/scratchpad/mutants
export PATH=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH
cd $M/tree
nice -n 10 ./build.sh > $M/build-base.log 2>&1 || { echo "base build failed"; exit 1; }
for m in $(python3 $M/mutants.py list); do
  python3 $M/mutants.py apply $m || { echo "$m: apply failed"; continue; }
  if nice -n 10 ./build.sh > $M/build-$m.log 2>&1; then
    timeout 600 ./build/compiler test-foreign > $M/foreign-$m.log 2>&1; f=$?
    timeout 600 ./build/compiler test-checker-driver --executable ./build/compiler --part 26/64 > $M/driver-$m.log 2>&1; d=$?
    fv=$(grep -a "foreign shared libraries' versions:" $M/foreign-$m.log)
    dv=$(grep -a "checker-driver: .* checks" $M/driver-$m.log)
    echo "$m: foreign exit $f ($fv); driver exit $d ($dv)"
  else
    echo "$m: BUILD FAILED"
  fi
  python3 $M/mutants.py revert $m || { echo "$m: revert failed"; exit 1; }
done
echo done
