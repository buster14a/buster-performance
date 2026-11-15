#!/bin/bash
# The compile A/B again, with CI's frozen corpus fetched into this task's directory (the record's corpus-391e729af658
# copy had been removed from the host, #2828): the fetch in a hold of its own, then compile-ab.sh, then the host's
# manifests in a hold.
B=~/buster-fast-bench/2678-claude
cd $B/bench
./lock.sh fetch-corpus bash -c 'rm -rf "$1/corpus" && bash "$1/head-e79a6338/tools/ci/fetch-corpus.sh" "$1/corpus"' _ $B > fetch.txt 2>&1
echo "fetch exit $?" >> fetch.txt
./compile-ab.sh $B/main-2ebfe68a/build/compiler $B/head-e79a6338/build/compiler $B/corpus 3 > compile.txt 2>&1
echo "compile exit $?" >> compile.txt
./lock.sh manifests ./host-manifests.sh > manifests.txt 2>&1
echo "finished" >> compile.txt
