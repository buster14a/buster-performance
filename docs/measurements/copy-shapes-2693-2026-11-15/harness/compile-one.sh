#!/bin/bash
# compile-one.sh TREE INPUT TIER: one locked run: -c of sqlite3.c or of main's main.c by TREE's compiler, one lane
# pinned to CPU 2, perf stat over 5 runs; one TSV line: tree, input, tier, task-clock ms, cycles, +-%, instructions,
# status, and the object's .text bytes (#1375's compile-one.sh, with the size).
set -uo pipefail
t=$1; input=$2; tier=$3
head -1 /var/lib/buster-9700x/owner >> record/holds.txt
src=../main/src
b=../$t/build/compiler
if [ $input = sqlite ]; then args=(sqlite3.c); else args=(-march=native -I$src -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1 $src/buster/compiler/main.c); fi
extra=(); if [ $tier = t1 ]; then extra=(--tier1); fi
o=/tmp/2693-claude-compile.$t.$input.$tier.o
out=$(perf stat -x, -r 5 -e cycles:u,instructions:u,task-clock taskset -c 2 $b -c --lanes 1 "${extra[@]}" -o $o "${args[@]}" 2>&1 >/dev/null)
status=$?
text=$(size -A $o 2>/dev/null | awk '$1==".text"{s+=$2} END{print s+0}')
rm -f $o
cyc=$(echo "$out" | awk -F, '$3=="cycles:u"{print $1}')
var=$(echo "$out" | awk -F, '$3=="cycles:u"{print $4}')
ins=$(echo "$out" | awk -F, '$3=="instructions:u"{print $1}')
ms=$(echo "$out" | awk -F, '$3=="task-clock"{print $1}')
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$t" "$input" "$tier" "$ms" "$cyc" "$var" "$ins" "$status" "$text"
