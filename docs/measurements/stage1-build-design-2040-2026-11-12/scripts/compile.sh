#!/bin/bash
# One compile of one unit by the build's own command with one change, to be run inside the 9700X lock (lock.sh), one
# compile a hold, pinned to CPU 2, written to scratch (the build's own outputs are untouched):
#   compile.sh TREE UNIT VARIANT
# TREE is a built clone under this directory, UNIT a source's name (main_unit_checker, c_parser_benchmark, ...).
#   plain          the build's command as it is (a split unit's ends at its optimized bitcode)
#   trace          with -ftime-trace at a granularity of 10 microseconds
#   unoptimized    stopped before LLVM's optimizer (-Xclang -disable-llvm-passes): the front end alone, and the bitcode
#                  the IR experiments and function_files read
#   nodebug        without -g
#   o2, o1, o0     at that level instead of -O3
#   o1-nodebug     -O1 without -g (the developer configuration's flags)
#   tests-optnone  with the unit's test functions marked optnone and noinline (scratch/UNIT.tests.csv, by test_list.py)
#   official       by the official LLVM release's clang that CI stages in ~/.cache/buster/benchpress-clang
#   syntax         the front end's parsing and semantic analysis alone (-fsyntax-only), without diagnostics' output
#   declarations   that with every function's body skipped (-Xclang -skip-function-bodies): what a piece of the unit
#                  that holds none of its functions would still parse
#   official-o0    that clang at -O0
# Results in results/compile: UNIT-VARIANT.time.txt (bash's time, the status, the output's size), .holder.txt, .log.
set -u
export LC_ALL=C
tree=$1; unit=$2; variant=$3
d=$HOME/buster-fast-bench/2040-claude
out=$d/results/compile
scratch=$d/scratch/compile
mkdir -p "$out" "$scratch"
cd "$d/$tree" || exit 2
mapfile -t command < <(python3 "$d/scripts/unit_command.py" build/compile_commands.json "$unit")
[ "${#command[@]}" -gt 3 ] || exit 2
official=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang
replace() { local i; for i in "${!command[@]}"; do [ "${command[$i]}" != "$1" ] || command[$i]=$2; done; }
remove() { local i kept=(); for i in "${!command[@]}"; do [ "${command[$i]}" = "$1" ] || kept+=("${command[$i]}"); done; command=("${kept[@]}"); }
extension=o
case $variant in
    plain) ;;
    trace) command+=("-ftime-trace=$out/$unit-trace.json" -ftime-trace-granularity=10) ;;
    unoptimized) command+=(-Xclang -disable-llvm-passes -emit-llvm); extension=bc ;;
    nodebug) remove -g ;;
    o2) replace -O3 -O2 ;;
    o1) replace -O3 -O1 ;;
    o0) replace -O3 -O0 ;;
    o1-nodebug) replace -O3 -O1; remove -g ;;
    tests-optnone) command+=(-mllvm "-forceattrs-csv-path=$d/scratch/$unit.tests.csv") ;;
    official) command[0]=$official ;;
    syntax) command+=(-fsyntax-only -w) ;;
    declarations) command+=(-fsyntax-only -w -Xclang -skip-function-bodies) ;;
    official-o0) command[0]=$official; replace -O3 -O0 ;;
    *) echo "unknown variant $variant" >&2; exit 2 ;;
esac
name=$unit-$variant
head -1 /var/lib/buster-9700x/owner > "$out/$name.holder.txt"
printf '%s\n' "${command[@]}" > "$out/$name.command.txt"
TIMEFORMAT='%R s wall, %U s user, %S s system'
{ time taskset -c 2 "${command[@]}" -o "$scratch/$name.$extension" > "$out/$name.log" 2>&1; } 2> "$out/$name.time.txt"
echo "status $?" >> "$out/$name.time.txt"
stat -c '%s bytes' "$scratch/$name.$extension" >> "$out/$name.time.txt" 2>&1
[ "$variant" != trace ] || gzip -1 -f "$out/$unit-trace.json"
echo "$name: $(tr '\n' ' ' < "$out/$name.time.txt")" >> "$d/results/compile.txt"
