#!/bin/bash
# throughput.sh LABEL: the compiler results/LABEL/compiler on sqlite3.c on the 9700X, CPU 2, each run its own hold of
# the lock: the file's bytes and its preprocessed bytes, then -fsyntax-only and -c with --time-stages, three runs each.
cd "$(dirname "$0")"
label=$1
. ./corpora.sh
out=$PWD/results/$label
tmp=$PWD/results/throughput-$label
mkdir -p "$tmp"
file=$(echo "$sqlite_arguments" | tr ' ' '\n' | grep 'sqlite3.c$')
echo "file $file bytes $(wc -c < "$file") lines $(wc -l < "$file")"
./lock.sh bash -c "taskset -c 2 $out/compiler -E $sqlite_arguments -o $tmp/sqlite3.i" > "$tmp/e.txt" 2>&1
echo "preprocessed bytes $(wc -c < "$tmp/sqlite3.i") lines $(wc -l < "$tmp/sqlite3.i")"
for n in 1 2 3; do
    for mode in syntax object; do
        if [ $mode = syntax ]; then options="-fsyntax-only"; else options="-c -o $tmp/sqlite3.o"; fi
        ./lock.sh bash -c "s=\$(date +%s%N); taskset -c 2 $out/compiler --time-stages $options $sqlite_arguments; status=\$?; e=\$(date +%s%N); echo \"wall-ns \$((e - s)) status \$status\"" > "$tmp/$mode-$n.txt" 2>&1
        echo "$mode $n: $(grep wall-ns "$tmp/$mode-$n.txt")"
    done
done
echo "object bytes $(wc -c < "$tmp/sqlite3.o")"
echo throughput finished
