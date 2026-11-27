#!/bin/bash
# faults.sh NAME...: every page fault of one compile of the one-function unit (perf record -e page-faults -c 1 -d),
# by the faulting address's mapping and the faulting code: results/faults-NAME.txt.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
printf 'int add(int a, int b) { return a + b; }\n' > /dev/shm/flt-3586.c
for name in "$@"; do
    out=$here/results/faults-$name.txt
    taskset -c 2 perf record -q -e page-faults -c 1 -d -o /dev/shm/flt-3586.data -- "$here/bin/compiler-$name" --lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" -c /dev/shm/flt-3586.c -o /dev/shm/flt-3586.o > /dev/null 2>&1
    perf script -i /dev/shm/flt-3586.data -F addr,ip,sym,dso 2>/dev/null > "$out"
    echo "$name: $(wc -l < "$out") faults"
done
rm -f /dev/shm/flt-3586.*
