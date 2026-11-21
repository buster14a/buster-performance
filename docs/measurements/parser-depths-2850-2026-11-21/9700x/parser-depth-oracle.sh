#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
until test -f results/oracle/.built; do sleep 5; done
source ./corpora.sh
mkdir -p oracle
python3 - "$root/oracle/bounds.c" <<'PY'
import sys
with open(sys.argv[1],'w') as w:
 for n in (1,6,7,8,31,62,63,64,65,128,2047,2100):
  w.write('int f'+str(n)+'(void){return '+'('*n+'1'+')'*n+';}\n')
PY
cd trees/before
exe=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/before/build.log"|head -1)
"$root/lock.sh" taskset -c 2 "$exe" -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$root/oracle/predefines.h"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
bounds_arguments="$root/oracle/bounds.c"
for c in bounds sqlite lua musl main; do
 key=${c}_arguments; eval "args=(${!key})"
 "$root/lock.sh" bash -c 'dst=$1; shift; exec env BUSTER_TEST_PARSE_DEPTH_REPLAY=1 taskset -c 2 "$@" > "$dst.out" 2>"$dst.err"' _ "$root/oracle/$c" "$root/results/oracle/compiler" -fsyntax-only "${args[@]}" > "$root/oracle/$c.lock" 2>&1
 echo "$c ok" >> "$root/oracle/status"
done
date -u +%FT%TZ > "$root/oracle/done"
