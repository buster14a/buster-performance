#!/bin/bash
# sections.sh TAG: under the 9700X's lock, each sanitizer's whole (src) and split executables' section headers and
# program headers, into results/TAG.
set -u
base=~/buster-fast-bench/2639-claude
out=$base/results/$1
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out" BASE="$base"
~/buster-fast-bench/exclusive.sh timeout -k 10 60 bash -c '
    for s in memory address thread; do
        for tree in src split; do
            readelf -SWl "$BASE/$tree/build/cmake/native-$s-O3/Release/compiler" > "$OUT/$s-$tree.txt"
        done
    done
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
