#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$PWD/results/active-direct-tiles
mkdir -p "$out/meter-src/buster/compiler"
src=$PWD/trees/activesourcetiles/src
source corpora.sh;eval "args=($sqlite_arguments)"
python3 - "$src" "$out" <<'PY'
from pathlib import Path
import sys
a,b=map(Path,sys.argv[1:])
f=a/'buster/compiler/c_preprocessor_impl.c'
s=f.read_text()
key='static PPPrepareStatus pp_prepare_fragment(';s=s.replace(key,'static unsigned long direct_calls,direct_lines,direct_names,direct_rows,direct_bytes,fragment_calls,prepared_bytes;\n'+key,1)
s=s.replace('        *result = part;','        fragment_calls += 1; prepared_bytes += end-from;\n        *result = part;',1)
s=s.replace('    uint32_t pos = from;\n    while (pos < data->length)','    direct_calls += 1;\n    uint32_t pos = from;\n    while (pos < data->length)',1)
s=s.replace('            out->count += count;\n            pp->input_tokens += count;', '            direct_rows += count; direct_names += __builtin_popcountll(_mm512_cmpeq_epi8_mask(packed_kinds,_mm512_set1_epi8(C_TOKEN_RAW_IDENTIFIER)));\n            out->count += count;\n            pp->input_tokens += count;',1)
s=s.replace('        pos += size + 1;\n    }\n    return pos;','        direct_lines += 1; direct_bytes += size+1;\n        pos += size + 1;\n    }\n    return pos;',1)
s=s.replace('static unsigned long direct_calls','static unsigned long good_tiles,tile_rows,tile_passed,tile_bytes,tile_tails;\nstatic unsigned long direct_calls',1)
s=s.replace('    if (stop == count || pp->fatal) { return end; }','    good_tiles++; tile_rows+=count; tile_passed+=stop; tile_bytes+=length; tile_tails+=stop!=count;\n    if (stop == count || pp->fatal) { return end; }',1)
target=b/'meter-src/buster/compiler'
(target/f.name).write_text(s)
for n in ['c_preprocessor.c','c_preprocessor_benchmark.c']:
 (target/n).write_bytes((a/'buster/compiler'/n).read_bytes())
h=Path('active-source-fresh.c').read_text().replace('    pp_release(&pp);','    fprintf(stderr,"attempts %lu lines %lu names %lu direct_rows %lu direct_bytes %lu fragments %lu retained_bytes %lu\\n",direct_calls,direct_lines,direct_names,direct_rows,direct_bytes,fragment_calls,prepared_bytes);\n    pp_release(&pp);')
h=h.replace('    pp_release(&pp);','    fprintf(stderr, "tiles %lu rows %lu passed %lu bytes %lu tails %lu\\n",good_tiles,tile_rows,tile_passed,tile_bytes,tile_tails);\n    pp_release(&pp);')
(b/'meter.c').write_text(h)
PY
./lock.sh taskset -c 2 bash -c '
 set -e
 out=$1;src=$2;shift 2
 export PATH="$(bash trees/factsmain0e1d/tools/ci/session-toolchain.sh stage):$PATH"
 clang -O3 -std=gnu17 -fwrapv -funsigned-char -march=native -I"$out/meter-src" -I"$src" -I"$src/buster/compiler" "$out/meter.c" -o "$out/meter"
 "$out/meter" "$@" >"$out/meter.tsv" 2>"$out/meter.err"
' _ "$out" "$src" "${args[@]}" >"$out/meter-build.log" 2>&1
