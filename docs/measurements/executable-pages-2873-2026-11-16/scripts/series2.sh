#!/bin/bash
# series2.sh: the record's runs, a hold of the lock each: main against `order` and against `full` (series.sh), a new
# executable's first runs as copied and as written (first.sh), the exit helper's look against none on the same
# executable (ab.sh with B_ENV), the peak resident set (peak.sh) and what the executable still faults (residual.sh).
cd "$(dirname "$0")"
./series.sh ab order full
log=series-rest.log
: > "$log"
run() { local start=$(date +%s); "$@" > "results/$1.log" 2>&1; echo "$? $(( $(date +%s) - start ))s $*" >> "$log"; }
step() { local name=$1; shift; local start=$(date +%s); ./lock.sh timeout -k 10 900 "$@" > "results/$name.log" 2>&1; echo "$? $(( $(date +%s) - start ))s $name" >> "$log"; }
step first-full ./first.sh full results/first-full
step first-full-written ./first.sh full results/first-full-written written
step first-main ./first.sh main results/first-main
B_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=0 step look-sqlite ./ab.sh results/look-sqlite sqlite 21 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler"
B_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=0 step look-musl ./ab.sh results/look-musl musl 5 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler"
B_ENV=BUSTER_EXECUTABLE_HUGE_PAGES=0 step look-syntax ./ab.sh results/look-syntax syntax 11 "full=$PWD/full/build/compiler" "nolook=$PWD/full/build/compiler"
step peak ./peak.sh results/peak 11 "main=$PWD/main/build/compiler" "full=$PWD/full/build/compiler"
step residual-full ./residual.sh full results/residual-full
step residual-order ./residual.sh order results/residual-order
step residual-main ./residual.sh main results/residual-main
echo done >> "$log"
