#!/bin/bash
# predef-prof.sh NAME N: user instructions by function over N compiles of a one-function unit, CPU 2, with the corpus's
# pinned predefines and with an empty predefines file: results/predef-prof-NAME/{pinned,empty}.txt (samples per compile).
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
name=$1; n=$2
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
tmp=$(mktemp -d /dev/shm/pdp-3586.XXXXXX)
out=$here/results/predef-prof-$name; mkdir -p "$out"
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
: > "$tmp/empty.h"
printf '#!/bin/bash\nfor ((i = 0; i < %d; i++)); do "$@"; done\n' "$n" > "$tmp/loop.sh"; chmod +x "$tmp/loop.sh"
for v in pinned empty; do
    case $v in
        pinned) p=$C/provenance/gnu17-pinned-predefines.txt;;
        empty) p=$tmp/empty.h;;
    esac
    taskset -c 2 perf record -q -e instructions:u -c 100003 -o "$out/$v.data" -- "$tmp/loop.sh" "$bin" --lanes 1 --predefines "$p" -c "$tmp/add.c" -o "$tmp/o.o" > /dev/null 2>&1
    perf report -i "$out/$v.data" --no-children --sort sym --stdio -F overhead,sample,sym 2>/dev/null | grep -v '^#' | grep -v '^$' | head -n 60 > "$out/$v.txt"
done
rm -rf "$tmp"
for v in pinned empty; do echo "== $v"; head -n 40 "$out/$v.txt"; done
