#!/bin/bash
# measure-one.sh BIN: one locked run (exclusive.sh calls it): the holder's line, the binary's checksum (one run),
# then perf stat (user mode) pinned to CPU 2, 10 runs, perf's exit status; one TSV line:
# binary, task-clock ms, cycles, cycles' +-%, instructions, ls_bad_status2.stli_other, checksum, status.
set -uo pipefail
b=$1
head -1 /var/lib/buster-9700x/owner >> record/holds.txt
test -x "$b" || { printf '%s\tmissing\n' "$b"; exit 1; }
sum=$(taskset -c 2 "./$b")
out=$(perf stat -x, -r 10 -e cycles:u,instructions:u,ls_bad_status2.stli_other:u,task-clock taskset -c 2 "./$b" 2>&1 >/dev/null)
status=$?
cyc=$(echo "$out" | awk -F, '$3=="cycles:u"{print $1}')
var=$(echo "$out" | awk -F, '$3=="cycles:u"{print $4}')
ins=$(echo "$out" | awk -F, '$3=="instructions:u"{print $1}')
stl=$(echo "$out" | awk -F, '$3 ~ /stli_other/{print $1}')
ms=$(echo "$out" | awk -F, '$3=="task-clock"{print $1}')
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$b" "$ms" "$cyc" "$var" "$ins" "$stl" "$sum" "$status"
