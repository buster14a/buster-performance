#!/bin/bash
set -eu -o pipefail
export CORES_LINK=https://github.com/buster14a/buster/pull/3214
tool_dir=$(cd "$(dirname "$0")" && pwd)
cd "${BUSTER_QA_TREE:-$tool_dir/../qa3204}"
out=${BUSTER_QA_OUT:-$tool_dir/../qa3204-results}
perf=${BUSTER_QA_PERF:-$tool_dir/../qa3204-inputs}
prior=$perf/tests-holes-2850-2026-11-21
compiler=$PWD/build/compiler
mkdir -p "$out"/{sweep,probes,fuzz}
if ! test -s "$out/sweep/extract.sha" || ! test "$(cat "$out/sweep/extract.sha")" = "$(git rev-parse HEAD)"; then
    CORES_TITLE="3204 extract checker programs" cores -n 1 -- python3 "$prior/sweep/extract.py" "$out/inline" src/buster/compiler/*_test.c > "$out/sweep/extract.log"
    git rev-parse HEAD > "$out/sweep/extract.sha"
fi
find "$out/inline" -name '*.c' | sort > "$out/inline.list"
git ls-files 'tests/*.c' | sort > "$out/tests.list"
for warn in default wall everything; do
  case $warn in default) options=();; wall) options=(-Wall -Wextra);; everything) options=(-Weverything -Wno-c++-compat);; esac
  for pile in tests inline; do
    CORES_TITLE="3204 $pile $warn" cores -n 2 -- python3 "$prior/sweep/sweep.py" "$compiler" "$out/sweep/$pile-$warn.tsv" "${CORES:-2}" "${options[@]}" < "$out/$pile.list" > "$out/sweep/$pile-$warn.log"
  done
done
python3 - "$out/ids.json" <<'PY'
import json,re,sys,pathlib
d=pathlib.Path('src/buster/compiler')
names=dict(re.findall(r'CHECK_WARNING_ID_(\w+)\s*=\s*(\d+)',((d/'c_check_warning_ids.c').read_text()+(d/'c_check_warning_events.c').read_text())))
tested=re.findall(r'\[CHECK_WARNING_ID_(\w+)\] = NODE_CENSUS_WARNING_TESTED',(d/'c_check_node_census.c').read_text())
json.dump([(int(names[n]),n,'TESTED','','') for n in tested],open(sys.argv[1],'w'))
PY
CORES_TITLE="3204 93 warning triggers" cores -n 1 -- python3 "$tool_dir/extend-triggers.py" "$prior/triggers/triggers.py" "$compiler" "$out/triggers" "$out"/sweep/{inline-default,tests-default,inline-wall,tests-wall,inline-everything,tests-everything}.tsv > "$out/triggers.txt"
export prior compiler out tool_dir
find "$perf" -path '*/probes/cases*.py' | CORES_TITLE='3204 one-statement probes' cores -n 2 -- xargs -P "${CORES:-2}" -I'{}' bash -ec 'python3 "$prior/probes/probe.py" "$compiler" "$1" > "$out/probes/$(basename "$1" .py).txt"' _ '{}'
export gen=$perf/summary-facts-2850-2026-11-21/fuzz/fuzz.py
seq 61 66 | xargs -P "${CORES:-2}" -I'{}' bash -ec 'n=$1; options=(); case "$n" in 62) export FUZZ_SEVERAL=1 FUZZ_PAD=1;; 63) export FUZZ_PRAGMA=1;; 64) options=(-Wall -Wextra);; 65) export FUZZ_SLOPPY=0.12;; 66) export FUZZ_SLOPPY=0.12 FUZZ_SEVERAL=1 FUZZ_PAD=1;; esac; CORES_TITLE="3204 generator seed $n" cores -n 1 -- python3 "$tool_dir/fuzz-checked.py" "$gen" "$compiler" "$n" 15000 "$out/fuzz/$n" "${options[@]}" > "$out/fuzz/$n.log"' _ '{}'
