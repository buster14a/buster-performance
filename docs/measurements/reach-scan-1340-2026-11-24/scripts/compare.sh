#!/bin/bash
# Every unit of the corpora under every warning set. Arguments: BASE HEAD CORPUS LUA CTESTSUITE OUT JOBS.
set -u
base=$1; head=$2; corpus=$3; lua=$4; cts=$5; out=$6; jobs=$7
here=$(dirname "$(readlink -f "$0")")
musl=$corpus/libc/musl
sqlite=$corpus/sqlite
rm -rf "$out"; mkdir -p "$out"
list=$out/units.txt
: > "$list"
i=0
for set_name in default wall families float-conversion implicit-float self-assign float-precision; do
    i=0
    {
        n=0
        n=$((n+1)); printf '%s\n' "$base|$head|$out|$set_name|$n|--|-DSQLITE_OMIT_LOAD_EXTENSION|-DSQLITE_THREADSAFE=0|-DSQLITE_ENABLE_MEMSYS5|-DSQLITE_ENABLE_RTREE|-I$sqlite|$sqlite/sqlite3.c"
        n=$((n+1)); printf '%s\n' "$base|$head|$out|$set_name|$n|--|-I$sqlite|$sqlite/shell.c"
        for f in "$lua"/src/*.c; do n=$((n+1)); printf '%s\n' "$base|$head|$out|$set_name|$n|--|-I$lua/src|$f"; done
        for f in "$cts"/tests/single-exec/*.c; do n=$((n+1)); printf '%s\n' "$base|$head|$out|$set_name|$n|--|$f"; done
        for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
            n=$((n+1)); printf '%s\n' "$base|$head|$out|$set_name|$n|--|-std=c99|-nostdinc|-ffreestanding|-D_XOPEN_SOURCE=700|-I|$musl/arch/x86_64|-I|$musl/arch/generic|-I|$corpus/musl-generated/obj/src/internal|-I|$musl/src/include|-I|$musl/src/internal|-I|$corpus/musl-generated/obj/include|-I|$musl/include|$f"
        done
    } >> "$list"
done
cd "$out"
# One line a unit; its fields are NUL-separated for xargs, a unit a line.
while IFS= read -r line; do printf '%s\n' "$line"; done < "$list" | xargs -P "$jobs" -d '\n' -n 1 bash -c 'IFS="|" read -r -a fields <<< "$1"; exec bash "$0" "${fields[@]}"' "$here/compare-unit.sh" > "$out/results.txt" 2> "$out/errors.txt"
echo "units: $(wc -l < "$list")  results: $(wc -l < "$out/results.txt")"
cut -d' ' -f1,2 "$out/results.txt" | sort | uniq -c
for set_name in default wall families float-conversion implicit-float self-assign float-precision; do
    echo "$set_name: $(grep -c " $set_name .* object=yes" "$out/results.txt") objects, $(awk -v s="$set_name" '$2 == s { split($6, d, "="); n += d[2] } END { print n + 0 }' "$out/results.txt") diagnostics; audit: $(awk -F'[ =]' '{ u += 1; a += $2; c += $4; k += $6; f += $8; l += $10 } END { printf "%d units, %d where the filter applies, %d candidates, %d kept, %d with a bit, %d lost", u, a, c, k, f, l }' "$out/$set_name.audit")"
done
