#!/bin/bash
# usage: lock.sh ./buildcost.sh VARIANT ; where clang's time goes on the stage 1 build's longest job, the checker's
# unity unit (front end and -O3 to bitcode; the build then splits the bitcode for eight backend jobs), one variant a
# hold, pinned to CPU 2, written to scratch (the build's own outputs are untouched). Results in results/buildcost.
#   trace    the build's own command with -ftime-trace
#   nodebug  without -g
#   o2, o1, o0   at that level instead of -O3
set -u
cd "$(dirname "$0")"
variant=${1:?a variant}
out=$PWD/results/buildcost
mkdir -p "$out" scratch/buildcost
src=$PWD/src
unit=${2:-checker}
base=(/usr/bin/clang -DCMAKE_INTDIR=\"Release\" -march=native "-I$src/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector
    -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_STRONG -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-pc-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1
    "-fmacro-prefix-map=$src/=" -emit-llvm -c "$src/src/buster/compiler/main_unit_$unit.c")
case $variant in
    trace) extra=(-g -O3 "-ftime-trace=$out/$unit-trace.json" -ftime-trace-granularity=2000) ;;
    nodebug) extra=(-O3) ;;
    o2) extra=(-g -O2) ;;
    o1) extra=(-g -O1) ;;
    o0) extra=(-g -O0) ;;
    *) echo "unknown variant" >&2; exit 2 ;;
esac
head -1 /var/lib/buster-9700x/owner > "$out/$unit-$variant.holder.txt"
TIMEFORMAT='%R s wall, %U s user, %S s system'
{ time taskset -c 2 "${base[@]}" "${extra[@]}" -o "scratch/buildcost/$unit-$variant.bc" > "$out/$unit-$variant.log" 2>&1; } 2> "$out/$unit-$variant.time.txt"
echo "status $?" >> "$out/$unit-$variant.time.txt"
ls -l "scratch/buildcost/$unit-$variant.bc" >> "$out/$unit-$variant.time.txt" 2>&1
