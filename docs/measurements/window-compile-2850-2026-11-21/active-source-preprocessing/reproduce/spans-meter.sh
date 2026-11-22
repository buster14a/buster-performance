#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$PWD/results/active-direct-spans;src=$PWD/trees/activesourcespans/src
mkdir -p "$out/meter-src/buster/compiler"
source corpora.sh;eval "args=($sqlite_arguments)"
python3 - "$src" "$out" <<'PY'
from pathlib import Path
import sys
src,d=map(Path,sys.argv[1:]);p=src/'buster/compiler/c_refine.c';s=p.read_text().replace('static bool refine_source_names(', 'static uint64_t attempts[2],hits[2];\nstatic bool refine_source_names(',1)
s=s.replace('        if (!found)\n        {\n            id=intern_find_or_add','        attempts[n>8]++; hits[n>8]+=found;\n        if (!found)\n        {\n            id=intern_find_or_add',1)
(d/'meter-src/buster/compiler/c_refine.c').write_text(s)
s=Path('active-source-fresh.c').read_text().replace('    pp_release(&pp);','    fprintf(stderr,"short attempted %lu hits %lu long attempted %lu hits %lu\\n",attempts[0],hits[0],attempts[1],hits[1]);\n    pp_release(&pp);')
(d/'meter.c').write_text(s)
PY
./lock.sh taskset -c 2 bash -c '
 set -e
 out=$1;src=$2;shift 2
 export PATH="$(bash trees/factsmain0e1d/tools/ci/session-toolchain.sh stage):$PATH"
 clang -O3 -std=gnu17 -fwrapv -funsigned-char -march=native -I"$out/meter-src" -I"$src" -I"$src/buster/compiler" "$out/meter.c" -o "$out/meter"
 "$out/meter" "$@" >"$out/meter.tsv" 2>"$out/meter.err"
' _ "$out" "$src" "${args[@]}" >"$out/meter-build.log" 2>&1
