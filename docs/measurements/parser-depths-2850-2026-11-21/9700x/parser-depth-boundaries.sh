#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
until test -f results/carried/.built; do sleep 5; done
mkdir -p boundaries/inputs
python3 - "$root/boundaries/inputs" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
for n in (1,5,6,7,8,31,62,63,64,65,128,2045,2046,2047,2048,2049,2100):
 (p/f"depth-{n}.c").write_text('int f(void) { return '+'('*n+'1'+')'*n+'; }\n')
for n in (1,62,63,64,65,126,127,128,129):
 # Long consecutive runs of semicolons shift a deep partial block to different transitions.
 (p/f"tail-{n}.c").write_text('int f(void) {'+';'*n+' return (1 + (2 * (3 + 4))); }\n')
PY
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
for v in before after packed carried; do
  s=0
  "$root/lock.sh" bash -c 'p=$1; shift; exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$root/boundaries/$v" "$root/results/$v/compiler" test-parser --files-only "$root"/boundaries/inputs/*.c >"$root/boundaries/$v.lock" 2>&1 || s=$?
  echo "$v $s" >> "$root/boundaries/status"
done
date -u +%FT%TZ > "$root/boundaries/done"
