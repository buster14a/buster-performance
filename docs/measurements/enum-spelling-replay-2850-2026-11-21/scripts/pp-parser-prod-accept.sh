#!/bin/bash
set -eu
cd "$(dirname "$0")/$1"
out=$PWD/../pp-parser-acceptance/$1
perf=$PWD/../perf/docs/measurements
prior=$perf/tests-holes-2850-2026-11-21
compiler=$PWD/build/compiler
./build.sh --config Develop > "$PWD/../$1-build.log" 2>&1
mkdir -p "$out"/{sweep,probes,fuzz}
python3 "$prior/sweep/extract.py" "$out/inline" src/buster/compiler/*_test.c > "$out/sweep/extract.log"
find "$out/inline" -name '*.c' | sort > "$out/inline.list"
git ls-files 'tests/*.c' | sort > "$out/tests.list"
for warn in default wall everything; do
  case $warn in default) options=();; wall) options=(-Wall -Wextra);; everything) options=(-Weverything -Wno-c++-compat);; esac
  for pile in tests inline; do
    python3 "$prior/sweep/sweep.py" "$compiler" "$out/sweep/$pile-$warn.tsv" 2 "${options[@]}" < "$out/$pile.list" > "$out/sweep/$pile-$warn.log"
  done
done
python3 - "$out/ids.json" <<'PY'
import json,re,sys,pathlib
d=pathlib.Path('src/buster/compiler')
names=dict(re.findall(r'CHECK_WARNING_ID_(\w+)\s*=\s*(\d+)',((d/'c_check_warning_ids.c').read_text()+(d/'c_check_warning_events.c').read_text())))
tested=re.findall(r'\[CHECK_WARNING_ID_(\w+)\] = NODE_CENSUS_WARNING_TESTED',(d/'c_check_node_census.c').read_text())
json.dump([(int(names[n]),n,'TESTED','','') for n in tested],open(sys.argv[1],'w'))
PY
python3 "$prior/triggers/triggers.py" "$compiler" "$out/triggers" "$out"/sweep/{inline-default,tests-default,inline-wall,tests-wall,inline-everything,tests-everything}.tsv > "$out/triggers.txt"
export prior compiler out
find "$perf" -path '*/probes/cases*.py' | xargs -P 2 -I'{}' bash -ec 'python3 "$prior/probes/probe.py" "$compiler" "$1" > "$out/probes/$(basename "$1" .py).txt"' _ '{}'
export gen=$perf/summary-facts-2850-2026-11-21/fuzz/fuzz.py
seq 61 66 | xargs -P 2 -I'{}' bash -ec 'n=$1; options=(); case "$n" in 62) export FUZZ_SEVERAL=1 FUZZ_PAD=1;; 63) export FUZZ_PRAGMA=1;; 64) options=(-Wall -Wextra);; 65) export FUZZ_SLOPPY=0.12;; 66) export FUZZ_SLOPPY=0.12 FUZZ_SEVERAL=1 FUZZ_PAD=1;; esac; python3 "$gen" "$compiler" "$n" 15000 "$out/fuzz/$n" "${options[@]}" > "$out/fuzz/$n.log"' _ '{}'
