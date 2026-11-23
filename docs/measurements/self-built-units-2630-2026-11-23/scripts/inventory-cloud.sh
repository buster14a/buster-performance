#!/bin/bash
# The correctness inventory by the hybrid Develop executable (BUSTER_SELF_BUILT=tests) in the cloud, in 3 shards.
cd /home/user/buster || exit 2
export PATH="/root/.cache/buster/toolchain/4444af0bee44de2d/build-tools/cmake-4.4.3-ninja-1.13.2/bin:/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:/root/.cache/buster/toolchain/4444af0bee44de2d/bin:$PATH" BUSTER_SELF_BUILT=tests BUSTER_CORPUS=/home/user/ci-inputs/corpus BUSTER_PPF_PRAGMA_ORACLE=/home/user/ci-inputs/pragma-oracle
export BUSTER_CLANG_RESOURCE_DIR="$(clang -print-resource-dir)"
out=/tmp/claude-0/inventory-cloud
mkdir -p $out
for k in 1 2 3; do
    rm -f build/oracle-*.tsv
    build/cmake/native/Develop/compiler parallel --jobs 4 --timeout 1200 --shard $k/3 --costs tools/ci/costs/native-none-O3.costs < tools/ci/correctness.tests > $out/shard-$k.log 2>&1
    echo "shard $k status $?" >> $out/status
done
echo done >> $out/status
