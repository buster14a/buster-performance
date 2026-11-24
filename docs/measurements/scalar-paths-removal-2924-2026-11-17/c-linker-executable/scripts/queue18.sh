#!/bin/sh
# After queue17 (piece 3 blocks): head against main exact, whole writes per output kind, one locked run each.
cd ~/buster-fast-bench/2924-linker
while ! { [ -f p3-tests.log ] && grep -q "^exit" p3-tests.log; }; do grep -q "^exit [1-9]" p3-build.log 2>/dev/null && exit 1; sleep 10; done
for only in links dynamic static static-pie shared; do
  ./run.sh ab-hexe-$only ./ab-hexe.sh $only 1,2,8,64,2000 3
done
