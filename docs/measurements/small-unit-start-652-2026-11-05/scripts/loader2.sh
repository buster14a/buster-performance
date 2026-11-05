#!/bin/sh
# The dynamic loader's share of a compile's start (#652): libm's load, and the lazy binding of the compiler's calls.
set -e
d=~/buster-fast-bench/652-claude-4
cd $d
C=$d/shifts-v1/compiler-0
printf '#include <stdio.h>\n#include <math.h>\nint main(int c, char** v){puts("x"); return c > 5 ? (int)sqrt((double)c) : 0;}\n' > hello-m.c
clang -O2 -no-pie hello.c -Wl,--no-as-needed -lm -o hello-dynamic-m
LD_DEBUG=bindings $C -fsyntax-only empty.c 2>&1 | grep -c "binding file $C" > bindings-syntax.txt || true
LD_DEBUG=bindings $C -c tiny.c -o /dev/null 2>&1 | grep -c "binding file $C" > bindings-compile.txt || true
LD_DEBUG=statistics $C -fsyntax-only empty.c > statistics-syntax.txt 2>&1 || true
~/buster-fast-bench/exclusive.sh sh -c "
taskset -c 2 perf stat -r 1001 -e task-clock,page-faults,cycles:u,cycles:k ./hello-dynamic-m > /dev/null 2> loader-dynamic-m.txt
taskset -c 2 perf stat -r 1001 -e task-clock,page-faults,cycles:u,cycles:k ./hello-dynamic > /dev/null 2> loader-dynamic-2.txt
taskset -c 2 perf stat -r 501 -e task-clock,page-faults,cycles:u,cycles:k $C -fsyntax-only empty.c 2> loader-compiler-lazy.txt
LD_BIND_NOW=1 taskset -c 2 perf stat -r 501 -e task-clock,page-faults,cycles:u,cycles:k $C -fsyntax-only empty.c 2> loader-compiler-now.txt
taskset -c 2 perf stat -r 501 -e task-clock,page-faults,cycles:u,cycles:k $C -c tiny.c -o /dev/null 2> loader-compile-lazy.txt
LD_BIND_NOW=1 taskset -c 2 perf stat -r 501 -e task-clock,page-faults,cycles:u,cycles:k $C -c tiny.c -o /dev/null 2> loader-compile-now.txt
"
for f in loader-dynamic-2 loader-dynamic-m loader-compiler-lazy loader-compiler-now loader-compile-lazy loader-compile-now; do echo "== $f"; grep -E "task-clock|page-faults|cycles|elapsed" $f.txt; done > loader2.txt
echo "bindings: syntax $(cat bindings-syntax.txt), compile $(cat bindings-compile.txt)" >> loader2.txt
cat statistics-syntax.txt >> loader2.txt
echo done > loader2.done
