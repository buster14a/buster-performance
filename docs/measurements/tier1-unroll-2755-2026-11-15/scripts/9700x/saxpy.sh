#!/usr/bin/env bash
# saxpy.sh: src/saxpy.c's seven loop bodies on CPU 2, three rounds in rotating order, with perf's user cycles and
# instructions; cycles per element = cycles / (100000 * 2048). Run under the lock from the loops directory.
set -u
cd "$(dirname "$0")"
head -1 /var/lib/buster-9700x/owner >> holds.txt
mkdir -p out/saxpy2
clang -O2 -march=znver5 src/saxpy.c -o out/saxpy2/saxpy || exit 1
for run in 1 2 3; do
    for step in 0 1 2 3 4 5 6; do
        mode=$(( (step + run) % 7 ))
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o out/saxpy2/perf.txt -- out/saxpy2/saxpy $mode 100000 > /dev/null
        status=$?
        c=$(grep cycles out/saxpy2/perf.txt | cut -d, -f1); i=$(grep instructions out/saxpy2/perf.txt | cut -d, -f1)
        echo "saxpy mode $mode run $run cycles $c instructions $i per-element $(awk -v c="$c" 'BEGIN { printf "%.4f", c / 204800000 }') status $status"
    done
done
