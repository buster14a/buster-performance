#!/bin/bash
# The PR's head with the fix: its build and tests (tests3.sh), then the h64x3 screen (screenH.sh) if the build passed.
D=~/buster-fast-bench/113-lanes-cloud
echo $$ > "$D/chain3.pid"
"$D/tests3.sh"
if grep -q "^done " "$D/tests3.txt" && ! grep -q "build failed" "$D/tests3.txt"; then
    "$D/screenH.sh" 5
fi
