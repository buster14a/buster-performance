#!/bin/bash
# locality.sh TREE NAME ROUNDS K...: whether a unit's bodies cost less in smaller batches. The frozen sqlite3.c is
# preprocessed once, cut by chunks.py, and each variant compiled (-c, one lane on CPU 2, -Wno-undefined-internal, since a
# kept body calls static functions whose bodies are gone) ROUNDS times in a rotating order, each variant's runs of a round
# one hold of the lock: a warm-up and a counters run (perf stat). results/locality-NAME/runs.tsv has every run.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
tree=$1; name=$2; rounds=$3; shift 3
cc="$dir/trees/$tree/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/locality-$name"
rm -rf "$out"; mkdir -p "$out/src"
"$cc" -E -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c" -o "$out/src/sqlite3.i"
python3 "$dir/chunks.py" "$out/src/sqlite3.i" "$out/src" "$@" > "$out/chunks.log"
variants=(whole none)
for k in "$@"; do for c in $(seq 0 $((k - 1))); do variants+=("k$k-c$c"); done; done
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: the bodies' cost by batch size (locality)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
count=${#variants[@]}
: > "$out/runs.tsv"
for i in $(seq 1 "$rounds"); do
    for j in $(seq 0 $((count - 1))); do
        v=${variants[$(( (i * 7 + j) % count ))]}
        "$HOME/buster-fast-bench/exclusive.sh" bash -c "
            cd '$out'
            taskset -c 2 '$cc' --lanes 1 -c -Wno-undefined-internal src/$v.i -o x.o > /dev/null 2> $v.stderr
            taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,L1-dcache-load-misses:u,page-faults -o x.perf -- '$cc' --lanes 1 -c -Wno-undefined-internal src/$v.i -o x.o > /dev/null 2>&1
            echo \"$v $i \$(awk -F, '/^[0-9]/ { printf \"%s \", \$1 }' x.perf) \$(sha256sum < x.o | cut -c1-12) \$(wc -l < $v.stderr)\" >> runs.tsv
            rm -f x.o x.perf
        " 2>> "$out/lock.log"
    done
done
rm -rf "$out/src"/k*.i
echo done > "$out/complete"
