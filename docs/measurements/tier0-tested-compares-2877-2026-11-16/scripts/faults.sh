#!/bin/bash
# faults.sh LABEL [RUNS]: every minor fault of a small compile (-c of musl's src/string/strlen.c) by a fresh copy of
# results/LABEL/compiler, with its address: perf record of minor-faults at period 1, CPU 2, one hold of the lock for
# the copy and its RUNS runs (default 5; the first warms the copy's pages). Then, no lock, each fault's address named
# by the executable's section and, in its data and code, by the symbol it is in (nm), counted over the last run.
# results/LABEL/faults.txt (the counts) and faults-addresses.txt (the last run's faults).
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; runs=${2:-5}
out=$PWD/results/$label
copy=/dev/shm/claude-2877-faults-$label
options=$(corpus_options musl)
./lock.sh bash -c "
    head -1 /var/lib/buster-9700x/owner | cut -c1-200
    cp $out/compiler $copy
    for run in \$(seq 1 $runs); do
        perf record -q -e 'minor-faults/period=1,call-graph=no/' -d -o $copy.data -- taskset -c 2 $copy -c $options $musl/src/string/strlen.c -o $copy.o
    done
    perf script -i $copy.data -F addr,ip,sym --ns 2> /dev/null > $out/faults-addresses.txt
    rm -f $copy.data $copy.o" > "$out/faults.log" 2>&1
echo "status $?" >> "$out/faults.log"
nm -n --defined-only "$copy" | awk '$2 ~ /^[tTdDbBrR]$/ { print $1, $2, $3 }' > "scratch/faults-symbols-$label.txt"
readelf -SW "$copy" | awk '/^ *\[ *[0-9]+\] \./ { line = $0; sub(/^ *\[ *[0-9]+\] /, "", line); split(line, f, " "); print f[3], f[5], f[1] }' > "scratch/faults-sections-$label.txt"
rm -f "$copy"
awk -v sections="scratch/faults-sections-$label.txt" -v symbols="scratch/faults-symbols-$label.txt" '
    BEGIN {
        while ((getline line < sections) > 0) { split(line, f, " "); ns += 1; sa[ns] = strtonum("0x" f[1]); se[ns] = sa[ns] + strtonum("0x" f[2]); sn[ns] = f[3] }
        while ((getline line < symbols) > 0) { split(line, f, " "); nm += 1; ma[nm] = strtonum("0x" f[1]); mn[nm] = f[3] }
    }
    {
        address = strtonum("0x" $1); where = "outside the executable (heap, stack, libraries, arenas)"; section = ""
        for (s = 1; s <= ns; s += 1) if (sa[s] != 0 && address >= sa[s] && address < se[s]) section = sn[s]
        if (section != "") {
            where = section
            if (section == ".data" || section == ".bss" || section == ".rodata") {
                low = 1; high = nm
                while (low < high) { mid = int((low + high + 1) / 2); if (ma[mid] <= address) low = mid; else high = mid - 1 }
                where = section " " mn[low]
            }
        }
        count[where] += 1; total += 1
    }
    END { for (w in count) printf "%6d %s\n", count[w], w; printf "%6d total\n", total }' "$out/faults-addresses.txt" | sort -k2 > "$out/faults.txt"
tail -1 "$out/faults.txt"
