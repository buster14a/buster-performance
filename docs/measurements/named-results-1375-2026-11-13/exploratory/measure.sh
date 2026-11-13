#!/bin/bash
# measure.sh BIN...: each binary's checksum (one run), then perf stat (user mode) pinned to CPU 2, 5 runs; a TSV line each.
set -euo pipefail
for b in "$@"; do
  test -x "$b"
  sum=$(taskset -c 2 "./$b")
  out=$(perf stat -x, -r 5 -e cycles:u,instructions:u,ls_bad_status2.stli_other:u,task-clock taskset -c 2 "./$b" 2>&1 >/dev/null)
  cyc=$(echo "$out" | awk -F, '$3=="cycles:u"{print $1}')
  ins=$(echo "$out" | awk -F, '$3=="instructions:u"{print $1}')
  stl=$(echo "$out" | awk -F, '$3 ~ /stli_other/{print $1}')
  ms=$(echo "$out" | awk -F, '$3=="task-clock"{print $1}')
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$b" "$ms" "$cyc" "$ins" "$stl" "$sum"
done
