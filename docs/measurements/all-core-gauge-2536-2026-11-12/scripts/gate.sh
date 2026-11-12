#!/bin/bash
# gate.sh PART: one part of the gauge (counted or sampled) on the record's executable, inside one hold of the lock;
# appends the hold's start, end and status to $out/holds.tsv.
set -u
cd "$(dirname "$0")"
part=${1:?counted or sampled}
out=${2:-results}
shift 2 2>/dev/null || shift
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
mkdir -p "$out" scratch
start=$(date +%s.%N)
head -1 /var/lib/buster-9700x/owner > "$out/$part.holder.txt"
./allcore "$part" --out "$out" "$@" -- ./src/build/compiler --time-stages --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
    -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "scratch/%l.w%w.o" 2> "$out/$part.log"
status=$?
end=$(date +%s.%N)
printf '%s\t%s\t%s\t%.3f\t%d\n' "$part" "$start" "$end" "$(awk -v a="$start" -v b="$end" 'BEGIN { printf "%.3f", b - a }')" "$status" >> $out/holds.tsv
cat "$out/$part.log"
exit $status
