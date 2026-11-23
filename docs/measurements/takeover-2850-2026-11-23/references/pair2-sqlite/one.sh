#!/bin/bash
# one.sh COMPILER KEY EXTRA -- ARGUMENT...: a warm-up, a wall run and a counters run of one compile, in the scratch directory.
set -uo pipefail
cc=$1; key=$2; extra=$3; shift 4
out=$(dirname "$0")
cd "$out/scratch"
manifest() { find . -maxdepth 1 -name '*.o' -print0 | sort -z | xargs -0 -r sha256sum | sha256sum | cut -d' ' -f1; }
cat /proc/loadavg > "$out/$key.load"
rm -f ./*.o
taskset -c 2 "$cc" $extra --lanes 1 -c "$@" > /dev/null 2> "$out/$key.warm.stderr"
rm -f ./*.o
taskset -c 2 python3 "$out/../../wallrun.py" "$out/$key" -- "$cc" $extra --lanes 1 -c "$@"
manifest > "$out/$key.sha"
find . -maxdepth 1 -name '*.o' | wc -l > "$out/$key.objects"
rm -f ./*.o
taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults -o "$out/$key.perf" -- "$cc" $extra --lanes 1 -c "$@" > /dev/null 2>&1
manifest >> "$out/$key.sha"
cat "$out/$key.stdout" "$out/$key.stderr" | sha256sum | cut -d' ' -f1 > "$out/$key.diag"
rm -f ./*.o
