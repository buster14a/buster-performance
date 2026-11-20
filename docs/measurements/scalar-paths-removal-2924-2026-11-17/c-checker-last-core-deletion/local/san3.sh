#!/bin/bash
# The sanitizer rows on the final head: vector host, memory then address; each built, then test-checker's eight parts
# test-checker-driver's first and second, test-checker-deferred and test-check-lanes, four at a time.
cd /home/user/buster-c12c3 || exit 1
O=/root/.cache/claude-c7/c12k/san3; mkdir -p $O; S=$O/status.txt; : > $S
T=$(dirname $(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin/clang | head -1))
echo "head $(git rev-parse --short HEAD)" >> $S
for san in memory address; do
    BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=$san ./build.sh > $O/build-$san.log 2>&1; echo "build $san: $?" >> $S
    exe=$(ls -d build/cmake/vector-$san-O3/*/compiler build/cmake/vector-$san-O3/compiler 2>/dev/null | head -1)
    cp "$exe" $O/compiler-$san; echo "executable $san: $exe" >> $S
    { for k in 1 2 3 4 5 6 7 8; do echo "PATH=$T:\$PATH $O/compiler-$san test-checker --seed 133 --part $k/8 > $O/$san-p$k.log 2>&1; echo \"$san checker $k exit \$?\" >> $S"; done
      for k in 1 2; do echo "PATH=$T:\$PATH $O/compiler-$san test-checker-driver --executable $O/compiler-$san --part $k/8 --in-process > $O/$san-d$k.log 2>&1; echo \"$san driver $k exit \$?\" >> $S"; done
      for t in test-checker-deferred test-check-lanes; do echo "PATH=$T:\$PATH $O/compiler-$san $t > $O/$san-$t.log 2>&1; echo \"$san $t exit \$?\" >> $S"; done; } > $O/cmds-$san
    cat $O/cmds-$san | xargs -P 4 -I{} sh -c '{}'
done
./build.sh > $O/build-develop.log 2>&1; echo "develop rebuild: $?" >> $S
echo done >> $S
