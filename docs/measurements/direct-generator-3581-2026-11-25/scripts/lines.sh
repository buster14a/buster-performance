#!/bin/bash
# lines.sh NAME: cycles and mispredicted branches by symbol+srcline from prof.sh's samples (no lock needed: reads files).
set -uo pipefail
here=$HOME/buster-fast-bench/3581-claude-hape45
out=$here/results/$1
for tag in cycles_u ex_ret_brn_misp_u instructions_u; do
  perf report -i "$out/$tag.data" --no-children --sort symbol,srcline -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -400 > "$out/$tag-lines.txt"
done
