#!/bin/bash
# A07b's and S03's probes (mutants7/probes): each C file checked with -fsyntax-only by clang, the head's build
# (623d0d18, -O3) and the mutant's build (-O1, mutate7.py's), printing each one's first two error or warning lines;
# with --run, each file also linked by the three and run, and the two builds' -c objects' SHA-256 printed.
# Usage: probes.sh [--run] HEAD_COMPILER MUTANT_COMPILER FILE...
run=0
[ "$1" = --run ] && { run=1; shift; }
H=$1 M=$2; shift 2
out=$(mktemp -d)
for f in "$@"; do
    echo "== $(basename $f)"
    for c in clang "$H" "$M"; do
        echo "  $c:"
        $c -std=gnu23 -march=native -fsyntax-only $f 2>&1 | grep -E 'error|warning' | head -2
        if [ $run = 1 ]; then
            $c -std=gnu23 -march=native -o $out/program $f && echo "  output: $($out/program)"
            [ $c != clang ] && $c -std=gnu23 -march=native -c -o $out/object.o $f && echo "  object: $(sha256sum < $out/object.o | cut -c1-64)"
        fi
    done
done
rm -rf $out
