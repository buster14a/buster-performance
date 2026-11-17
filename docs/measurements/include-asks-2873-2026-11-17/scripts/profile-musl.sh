#!/bin/bash
# profile-musl.sh OUT NAME=COMPILER...: where a pass of musl's units, a process each, spends its kernel cycles by each
# compiler (perf record on CPU 2 as a whole, kernel cycles with stacks; a fresh copy of the executable, a pass of
# warm-up first), and one unit's page faults by each, every one with its address and the code that took it.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
shift
mkdir -p "$out"
source ../scripts/musl-common.sh
for spec in "$@"; do
    name=${spec%%=*}
    cp "${spec#*=}" "$out/$name.compiler"
    bash ab.sh --work musl "$here/$out/$name.compiler" "$name" > /dev/null 2>&1
    taskset -c 4 perf record -q -C 2 -e cpu/cycles,period=100003/k -g -o "$out/$name.data" -- bash ab.sh --work musl "$here/$out/$name.compiler" "$name" > /dev/null 2> "$out/$name.err"
    perf report -i "$out/$name.data" --no-children --sort symbol --stdio -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -80 > "$out/$name.symbols.txt"
    perf report -i "$out/$name.data" --no-children --sort comm --stdio -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -12 > "$out/$name.comms.txt"
    perf report -i "$out/$name.data" --stdio --header-only 2> /dev/null | grep -i "sample\|lost" | head -5 > "$out/$name.header.txt"
    perf script -i "$out/$name.data" -F period 2> /dev/null | awk '{n += 1} END {print n " samples"}' >> "$out/$name.header.txt"
    for unit in string/strlen.c stdio/vfprintf.c; do
        label=$(basename "$unit" .c)
        taskset -c 2 perf record -q -e 'minor-faults/period=1,call-graph=no/' -d -o "$out/$name-$label.faults.data" -- "$here/$out/$name.compiler" "${options[@]}" -c "$musl/src/$unit" -o /dev/shm/2873-profile.o > /dev/null 2> "$out/$name-$label.faults.err"
        perf script -i "$out/$name-$label.faults.data" -F ip,sym,addr 2> /dev/null > "$out/$name-$label.faults.txt"
    done
    rm -f "$out/$name.compiler" "$out"/*.faults.data /dev/shm/2873-profile.o
done
