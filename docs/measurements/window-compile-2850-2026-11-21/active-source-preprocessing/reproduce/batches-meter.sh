#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$PWD/results/active-direct-batches;src=$PWD/trees/activesourcebatches/src
mkdir -p "$out/meter-src/buster/compiler"
source corpora.sh;eval "args=($sqlite_arguments)"
python3 - "$src" "$out" <<'PY'
from pathlib import Path
import sys
src,d=map(Path,sys.argv[1:]);p=src/'buster/compiler/c_refine.c';s=p.read_text()
s=s.replace('static bool refine_source_names(', 'static uint64_t total_names,short_names_probed,hits_found;\nstatic bool refine_source_names(',1)
s=s.replace('    RefineIdentifiers pending;','    RefineIdentifiers pending;\n    total_names+=names->count;',1)
s=s.replace('            const __mmask8 misses = real & ~hits;','            short_names_probed+=__builtin_popcount(readable);\n            hits_found+=__builtin_popcount(hits);\n            const __mmask8 misses = real & ~hits;',1)
(d/'meter-src/buster/compiler/c_refine.c').write_text(s)
s=Path('active-source-fresh.c').read_text().replace('    pp_release(&pp);','    fprintf(stderr,"total %lu short %lu hits %lu\\n",total_names,short_names_probed,hits_found);\n    pp_release(&pp);')
(d/'meter.c').write_text(s)
PY
./lock.sh taskset -c 2 bash -c '
 set -e
 out=$1;src=$2;shift 2
 export PATH="$(bash trees/factsmain0e1d/tools/ci/session-toolchain.sh stage):$PATH"
 clang -O3 -std=gnu17 -fwrapv -funsigned-char -march=native -I"$out/meter-src" -I"$src" -I"$src/buster/compiler" "$out/meter.c" -o "$out/meter"
 "$out/meter" "$@" >"$out/meter.tsv" 2>"$out/meter.err"
' _ "$out" "$src" "${args[@]}" >"$out/meter-build.log" 2>&1
