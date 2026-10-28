#!/bin/bash
# Where a head's extra instructions go: perf record of user instructions at a period under the kernel's sample-rate cap
# (perf_event_max_sample_rate, 63,300 per second, which throttled periods of 20,011 and 200,003 at peak IPC), over 100 runs of the frozen
# sqlite3.c by each tree, each under its own hold of the 9700X's lock, pinned to CPU 2; then each sample's address
# resolved against the tree's own symbols (nm), since perf's report resolves these 32-byte build IDs from stale caches.
# Usage: profile.sh DIRECTORY BASE HEAD drive|lower
set -u
directory=$1 base=$2 head=$3 mode=$4
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): where $head's instructions go" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
if [ "$mode" = drive ]; then arguments=(-fsyntax-only --clang-features "${lower[@]}"); else arguments=(-c -o /dev/null "${lower[@]}"); fi
cd ~/buster-fast-bench/claude-126-cloud/$directory
export TMPDIR=$PWD/tmp
mkdir -p tmp
for tree in $base $head; do
    command="for i in \$(seq 100); do $tree/build/compiler ${arguments[*]} > /dev/null 2>&1; done"
    $lock perf record -q -e instructions:u -c 1000003 -o profile_${tree}_$mode.data taskset -c 2 bash -c "$command" > /dev/null 2>&1
    nm -n --defined-only $tree/build/compiler | awk '$2 ~ /^[tTwW]$/ {print $1, $3}' > nm_$tree.txt
    perf script -i profile_${tree}_$mode.data -F comm,ip 2>/dev/null | awk '$1 == "compiler" {print $2}' > ips_$tree.txt
    awk 'NR == FNR { address[n] = strtonum("0x" $1); name[n] = $2; n++; next }
         { ip = strtonum("0x" $1); lo = 0; hi = n - 1; found = -1
           while (lo <= hi) { mid = int((lo + hi) / 2); if (address[mid] <= ip) { found = mid; lo = mid + 1 } else { hi = mid - 1 } }
           count[found >= 0 ? name[found] : "?"]++ }
         END { for (s in count) print count[s], s }' nm_$tree.txt ips_$tree.txt | sort -n -r > functions_${tree}_$mode.txt
    echo "$tree $mode: $(wc -l < ips_$tree.txt) samples in $(wc -l < functions_${tree}_$mode.txt) functions"
done
