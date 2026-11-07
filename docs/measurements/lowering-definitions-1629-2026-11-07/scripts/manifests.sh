#!/bin/bash
# #1629's record: the host's, the trees' and the inputs' identities. main418 is #442's tree (its source manifest is in
# that record); the others are this directory's.
cd ~/buster-fast-bench/1629-claude
mkdir -p manifests
{
    echo "host: $(uname -n)"
    uname -srvmo
    grep -m1 "model name" /proc/cpuinfo
    echo "cpus: $(nproc --all)"
    clang --version | head -1
    cmake --version | head -1
    ninja --version
    echo "THP: $(cat /sys/kernel/mm/transparent_hugepage/enabled)"
    echo "governor cpu2: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null)"
    echo "boost: $(cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null)"
} > manifests/host.txt
: > manifests/trees.new
echo "main418 executable $(sha256sum < trees/main418/build/compiler | cut -c1-64) (#442's tree: lowering-fixed-cost-442-2026-11-06/manifests)" >> manifests/trees.new
for t in main c1 c2 c3 c4 c5 c6; do
    (cd trees/$t && find src tools build.sh CMakeLists.txt cmake -type f 2>/dev/null | LC_ALL=C sort | xargs sha256sum) > manifests/source-$t.sha256
    echo "$t source-manifest $(sha256sum < manifests/source-$t.sha256 | cut -c1-64) executable $(sha256sum < trees/$t/build/compiler | cut -c1-64)" >> manifests/trees.new
done
mv manifests/trees.new manifests/trees.txt
cp trees/trees.txt manifests/build-trees.txt
(cd cts && git rev-parse HEAD && ls tests/single-exec/*.c | LC_ALL=C sort | xargs sha256sum) > manifests/c-testsuite.sha256
(ls synthetic/*.c | LC_ALL=C sort | xargs sha256sum) > manifests/synthetic.sha256
sha256sum patches/*.patch *.sh scripts/* > manifests/scripts-and-patches.sha256
echo manifests-done
