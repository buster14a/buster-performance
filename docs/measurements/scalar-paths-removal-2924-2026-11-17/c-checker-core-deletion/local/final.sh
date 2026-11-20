#!/bin/bash
# After the digest flips: ASan on the head (test-checker's eight parts), the tests commit's sixteen parts, the head's Develop.
C=/root/.cache/claude-c7/c12k; O=$C/final; mkdir -p $O; S=$O/status.txt; : > $S
T=$(dirname $(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin/clang | head -1))
( cd /home/user/buster-c12kt && git checkout -q --detach 2ca88b353 && echo "tests tree $(git rev-parse --short HEAD)" >> $S && nice -n 5 ./build.sh > $O/build-t.log 2>&1; echo "tests build: $?" >> $S ) &
( cd /home/user/buster-c12k && echo "head $(git rev-parse --short HEAD)" >> $S && BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=address nice -n 5 ./build.sh > $O/build-asan.log 2>&1; echo "asan build: $?" >> $S ) &
wait
A=/home/user/buster-c12k/build/cmake/vector-address-O3/Develop/compiler; cp $A $O/compiler-address
for half in "1 2 3 4" "5 6 7 8"; do
    for k in $half; do (cd /home/user/buster-c12k && PATH=$T:$PATH $O/compiler-address test-checker --seed 133 --part $k/8 > $O/address-p$k.log 2>&1; echo "address checker $k exit $?" >> $S) & done; wait
done
sed -e "s|O=/root/.cache/claude-c7/c12k/tparts2|O=$O/tparts|" $C/tparts2.sh > $O/tparts.sh; bash $O/tparts.sh; echo "tests parts done" >> $S
( cd /home/user/buster-c12k && ./build.sh > $O/build-dev.log 2>&1; echo "head develop: $?" >> $S )
echo done >> $S
