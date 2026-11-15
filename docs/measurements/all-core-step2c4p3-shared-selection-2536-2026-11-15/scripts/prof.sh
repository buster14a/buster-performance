#!/bin/bash
# prof.sh NAME DIRECTORY FILE OPTIONS...: FILE from DIRECTORY on CPU 2 by HEAD's -c and --windowed-loop -c, 8 runs of each
# under perf record (cycles:u, a period of 200003 + 2i for run i, so that the runs sample different instructions), then
# each mode's cycles by symbol (out/NAME.prof.MODE.txt).
set -u
name=$1 directory=$2 file=$3
shift 3
here=$PWD
out=$PWD/out
mkdir -p "$out/o" "$out/perf"
cd "$directory" || exit 1
for mode in plain windowed; do
    extra=""
    [ "$mode" = windowed ] && extra=--windowed-loop
    for i in 0 1 2 3 4 5 6 7; do
        perf record -q -e cycles:u -c $((200003 + 2 * i)) -o "$out/perf/$name.$mode.$i.data" taskset -c 2 "$here/compiler-head" --lanes 1 $extra "$@" -c "$file" -o "$out/o/$name.$mode.o" 2> /dev/null < /dev/null
    done
done
for mode in plain windowed; do
    for i in 0 1 2 3 4 5 6 7; do
        perf report -q -i "$out/perf/$name.$mode.$i.data" --sort symbol --stdio -F overhead,sample,symbol 2> /dev/null
    done | awk '{ count[$4] += $2; total += $2 } END { for (s in count) printf "%d\t%s\n", count[s], s; printf "%d\tTOTAL\n", total }' | sort -rn > "$out/$name.prof.$mode.txt"
done
