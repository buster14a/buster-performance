#!/bin/bash
# run-ab.sh: builds the kernels by main, nrvo and narrow (nrvo with every inline copy in 8-byte pieces), each under the
# lock, then measures them under the lock. Writes run-ab.pid, results-ab.tsv and run-ab.done.
set -euo pipefail
cd ~/buster-fast-bench/1375-claude/harness
echo $$ > run-ab.pid
rm -f run-ab.done
export EXCLUSIVE_OWNER=claude-1375 EXCLUSIVE_TITLE="#1375 NRVO A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1375
(cd ../narrow && ~/buster-fast-bench/exclusive.sh ./build.sh)
test -x ../narrow/build/compiler
rm -rf bin
for t in main nrvo narrow; do ~/buster-fast-bench/exclusive.sh ./build-kernels.sh ../$t/build/compiler $t; done
list=()
for k in k24 k16 k64 assign8 assign16 assign32 cold8 cold16 cold32; do
    for t in main nrvo narrow; do list+=(bin/$k.$t.t0 bin/$k.$t.t1); done
    list+=(bin/$k.clang)
done
~/buster-fast-bench/exclusive.sh ./measure.sh "${list[@]}" > results-ab.tsv
echo done > run-ab.done
