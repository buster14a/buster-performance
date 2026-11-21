#!/bin/bash
set -eu
if (($# != 3)); then echo "usage: replay.sh COMPILER SQLITE_DIR RESULTS_DIR" >&2; exit 1; fi
cc=$(realpath "$1"); sqlite=$(realpath "$2"); mkdir -p "$3"; out=$(realpath "$3"); this=$(dirname "$(realpath "$0")")
args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
export NODE_PROOF_POINTERS=1 NODE_PROOF_NO_FP=1
for r in 1 2 3 4 5 6 7; do
 if ((r%2)); then modes=(identity pack); else modes=(pack identity); fi
 for mode in "${modes[@]}"; do
  if ((r==1)); then export BUSTER_GRAPH_STORAGE="$out/$mode-columns.tsv"; else unset BUSTER_GRAPH_STORAGE; fi
  NODE_PROOF_PACKED_REPLAY="$mode" "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" > "$out/$r-$mode.stdout" 2> "$out/$r-$mode.stderr"
  rg '^storage-(phase|replay)' "$out/$r-$mode.stderr" > "$out/$r-$mode.log"
 done
done
python3 "$this/phase-summary.py" "$out" > "$out/summary.json"
