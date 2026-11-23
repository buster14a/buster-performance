#!/bin/bash
# cross.sh: src's test-calling-convention --cross-check (#137's cross-linking, our side by Tier 0 and by --tier1
# --verify, against clang 23.1.4 and GCC) on CPUs 2-9... in one hold of the lock, from src's root.
set -u
cd "$(dirname "$0")"
mkdir -p results
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
clang_dir=$(ls -d ~/.cache/buster/benchpress-clang/*/ | head -1)
export PATH="${clang_dir}bin:$PATH"
{ command -v clang; clang --version | head -1; gcc --version | head -1; echo "src $(cat src.commit)"; } > results/cross.env 2>&1
./lock.sh bash -c "head -3 /var/lib/buster-9700x/owner; cd src && time ./build/compiler test-calling-convention --cross-check" > results/cross.txt 2>&1
echo "exit $?" >> results/cross.txt
