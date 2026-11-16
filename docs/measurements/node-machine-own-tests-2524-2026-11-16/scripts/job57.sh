#!/bin/bash
# job57.sh: what of the own form's pass is its three lookups by index. o8y is the eighth build with the parts' knob and
# three more bits: the type's byte not looked up (512), the token's role not looked up (1024), the operands' bytes not
# looked up (2048). With the four lists off (15), the pass alone remains: with each lookup off, and with all three.
set -u
cd "$(dirname "$0")"
while systemctl --user is-active -q claude-2524-job56; do sleep 15; done
./build-label.sh o8y be6515fba o8y.patch > results/o8y-build.out 2>&1 || { echo "o8y build failed" >> results/job57.log; exit 1; }
./skips-p.sh o8y 1 7 15 527 1039 2063 3599 31
echo "job57 done $(date -u +%FT%TZ)" >> results/job57.log
