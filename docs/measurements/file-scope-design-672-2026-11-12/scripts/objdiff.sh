#!/bin/bash
# objdiff.sh NAME...: for each unit NAME, its object from scratch/musl-i and from scratch/musl-live (through one
# path, scratch/cur), and their differences by readelf and objdump, inside one hold of the lock.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/live/objdiff
here=$PWD
mkdir -p "$out" scratch/od-i scratch/od-live
compiler=$PWD/src/build/compiler
for n in "$@"; do
    rm -f scratch/cur; ln -s "$here/scratch/musl-i" scratch/cur
    (cd scratch/od-i && "$compiler" "${musl_i_options[@]}" --lanes 1 -c "$here/scratch/cur/$n.i" -o "$n.o" 2> /dev/null)
    rm -f scratch/cur; ln -s "$here/scratch/musl-live" scratch/cur
    (cd scratch/od-live && "$compiler" "${musl_i_options[@]}" --lanes 1 -c "$here/scratch/cur/$n.i" -o "$n.o" 2> /dev/null)
    rm -f scratch/cur
    {
        echo "## $n: sizes"; ls -l scratch/od-i/$n.o scratch/od-live/$n.o | awk '{ print $5, $9 }'
        echo "## readelf -S -s -r differences"
        diff <(readelf -W -S -s -r scratch/od-i/$n.o 2>&1) <(readelf -W -S -s -r scratch/od-live/$n.o 2>&1) | head -60
        echo "## objdump -d differences"
        diff <(objdump -d -r scratch/od-i/$n.o 2>&1 | tail -n +3) <(objdump -d -r scratch/od-live/$n.o 2>&1 | tail -n +3) | head -40
        echo "## section contents differences (objdump -s)"
        diff <(objdump -s scratch/od-i/$n.o 2>&1 | tail -n +3) <(objdump -s scratch/od-live/$n.o 2>&1 | tail -n +3) | head -40
    } > "$out/$n.txt" 2>&1
done
rm -rf scratch/od-i scratch/od-live
