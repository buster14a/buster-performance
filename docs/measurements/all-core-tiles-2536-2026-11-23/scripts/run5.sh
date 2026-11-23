#!/bin/bash
# run5.sh TREE OUT CONFIG...: pair5.sh under the lock, then each configuration's table.
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
tree=${1:?tree}; outname=${2:?out}
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the all-core path, a paired gauge"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
~/buster-fast-bench/exclusive.sh "$dir/pair5.sh" "$@" 2> "$dir/results/$outname.lock.err"
out=$dir/results/$outname
cd "$dir/$tree"
for g in "$out"/*.[ab]; do
    build/allcore table --out "$g" --bytes 9507037 > "$g/table.out" 2>&1 || true
    sha256sum "$g"/*.o | awk '{print $1}' | sort | uniq -c > "$g/objects.txt"
done
echo "RUN-DONE $outname"
