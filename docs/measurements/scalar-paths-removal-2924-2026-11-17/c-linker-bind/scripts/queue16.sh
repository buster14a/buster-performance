#!/bin/sh
# After queue15 (piece 2 blocks): head against main at the gate sizes the A/B skipped, 8 and 256 workers.
cd ~/buster-fast-bench/2924-linker
while ! grep -q "^exit" queue15.done 2>/dev/null; do [ -f p2-tests.log ] && grep -q "^exit" p2-tests.log && break; grep -q "^exit [1-9]" p2-build.log 2>/dev/null && exit 1; sleep 10; done
./run.sh ab-hbind-mid ./ab-hbind.sh 8,256 3
