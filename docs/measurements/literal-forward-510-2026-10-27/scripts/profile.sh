#!/usr/bin/env bash
# profile.sh TREE: 16 compiles of sqlite3.c by TREE's executable at shift 0, sampled on cycles and on failed
# store-to-load forwards, pinned to CPU 2; then the literal functions' annotated samples. Run under the lock.
set -u
here="$HOME/buster-fast-bench/literal-510"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
b="$here/bin/$1-s0"
d="$here/results/perf-$1"
mkdir -p "$d"
export b
export sqlite_line="${sqlite[*]}"
taskset -c 2 perf record -q -o "$d/cycles.data" -e cycles:u -c 100003 -- bash -c 'for ((i = 0; i < 16; i += 1)); do $b -fsyntax-only $sqlite_line > /dev/null; done'
taskset -c 2 perf record -q -o "$d/stli.data" -e ls_bad_status2.stli_other:u -c 1009 -- bash -c 'for ((i = 0; i < 16; i += 1)); do $b -fsyntax-only $sqlite_line > /dev/null; done'
for e in cycles stli; do
    echo "== $e by symbol"
    perf report -i "$d/$e.data" --stdio --sort sym -n 2>/dev/null | grep -v '^$' | head -40
    for f in check_literal_number_plain check_literal_number check_input_literal; do
        echo "== $e: $f"
        perf annotate -i "$d/$e.data" --stdio -s "$f" 2>/dev/null | awk '$1 + 0 > 0.5' | sort -rn | head -12
    done
done
