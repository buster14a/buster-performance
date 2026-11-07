#!/bin/bash
# #1629, second part: the trees' identities (main418w, mainw, c7w) and the inputs', for the record.
cd ~/buster-fast-bench/1629-claude
mkdir -p manifests2
for t in main418w mainw c7w; do
    (cd trees/$t && find src tools build.sh CMakeLists.txt cmake -type f 2>/dev/null | LC_ALL=C sort | xargs sha256sum) > manifests2/source-$t.sha256
    echo "$t source-manifest $(sha256sum < manifests2/source-$t.sha256 | cut -c1-64) executable $(sha256sum < trees/$t/build/compiler | cut -c1-64)" >> manifests2/trees.new
done
mv manifests2/trees.new manifests2/trees.txt
grep -E "^(main418w|mainw|c7w) " trees/trees.txt > manifests2/build-trees.txt
sha256sum patches/c7.patch setup2.sh rounds4.sh round4.sh perf1629.sh perf1629b.sh scripts-w/* > manifests2/scripts-and-patches.sha256
cp manifests/host.txt manifests/c-testsuite.sha256 manifests/synthetic.sha256 manifests2/
echo manifests2-done
