#!/bin/bash
# What a clang oracle run costs alone, against the same inputs in one clang invocation, and against buster's process:
# 40 one-function fixtures with a warning each, -fsyntax-only, plain builds, without CPATH.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
d=$(mktemp -d "$D/clang.XXXX")
cd "$d" || exit 2
for ((i = 1; i <= 40; i++)); do
    printf 'int f%d(int x) { int unused; return x << 33; }\n' "$i" > "f$i.c"
done
TIMEFORMAT='%R'
t1=$( { time for ((i = 1; i <= 40; i++)); do env -u CPATH clang -std=gnu17 -fsyntax-only -fno-caret-diagnostics "f$i.c" 2> /dev/null; done; } 2>&1 )
t2=$( { time env -u CPATH clang -std=gnu17 -fsyntax-only -fno-caret-diagnostics f*.c 2> /dev/null; } 2>&1 )
t3=$( { time for ((i = 1; i <= 40; i++)); do env -u CPATH "$D/compiler-plain4" -std=gnu17 -fsyntax-only -fno-caret-diagnostics "f$i.c" 2> /dev/null; done; } 2>&1 )
echo "40 clang processes: $t1 s; one clang with 40 inputs: $t2 s; 40 buster processes: $t3 s"
echo "--- one clang with 3 inputs:"
env -u CPATH clang -std=gnu17 -fsyntax-only -fno-caret-diagnostics f1.c f2.c f3.c 2>&1
echo "status=$?"
