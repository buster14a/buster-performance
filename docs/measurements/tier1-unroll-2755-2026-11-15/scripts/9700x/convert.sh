#!/usr/bin/env bash
# convert.sh: src/convert.c's four forms of int32 -> float conversion on CPU 2, three runs each, with perf's user
# cycles and instructions; cycles per conversion = cycles / 2^30. Run under the lock from the loops directory.
set -u
cd "$(dirname "$0")"
head -1 /var/lib/buster-9700x/owner >> holds.txt
mkdir -p out/convert
clang -O2 -march=znver5 src/convert.c -o out/convert/convert || exit 1
for run in 1 2 3; do
    for mode in 0 1 2 3; do
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o out/convert/perf.txt -- out/convert/convert $mode > /dev/null
        status=$?
        c=$(grep cycles out/convert/perf.txt | cut -d, -f1); i=$(grep instructions out/convert/perf.txt | cut -d, -f1)
        echo "convert mode $mode run $run cycles $c instructions $i per-conversion $(awk -v c="$c" 'BEGIN { printf "%.4f", c / 1073741824 }') status $status"
    done
done
