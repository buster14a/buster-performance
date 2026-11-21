#!/usr/bin/env bash
# Run inside a core reservation. The input amalgamation is identified by inputs.sha256.
# Usage: bash reproduce.sh /path/to/Buster-git-clone /path/to/sqlite3.c /fresh/out
set -euo pipefail
study=$(cd "$(dirname "$0")" && pwd)
repo=$(realpath "$1")
src=$(realpath "$2")
out=$(realpath -m "$3")
mkdir -p "$out"
git -C "$repo" worktree add --detach "$out/compiler-source" 84a7d3d76891d6c393497e62e6aff38f2b162fc2
build="$out/compiler-source"
for p in "$study"/0{1,2,3,4,5}*.patch.gz; do gzip -cd "$p" | git -C "$build" apply -; done
(cd "$build" && ./build.sh)
gzip -cd "$study/proof-predefines.h.gz" > "$build/build/predefines.h"
cc="$build/build/compiler"
opts=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$(dirname "$src")" "$src")
common=(NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1 NODE_SPLICE_FRONT=1 NODE_SPLICE_ENABLE=1 NODE_SPLICE_REPORT=1)
for kind in plain ordinary source lookup demand local-access; do
    vars=()
    case $kind in
        ordinary) vars=("${common[@]}");;
        source) vars=("${common[@]}" NODE_SOURCE_ONLY=1);;
        lookup) vars=("${common[@]}" NODE_SOURCE_ONLY=1 NODE_SOURCE_REFRESH_POINTERS=1);;
        demand) vars=("${common[@]}" NODE_SOURCE_ONLY=1 NODE_SOURCE_DEMAND_POINTERS=1);;
        local-access) vars=("${common[@]}" NODE_SOURCE_COMPACT=1 NODE_SOURCE_LOCAL_ACCESS=1 NODE_SOURCE_COMPACT_REPORT=1);;
    esac
    NODE_SOURCE_WINDOW_WATCH="$study/missing-tokens.txt" NODE_SOURCE_GRAPH_ORACLE="$out/$kind.bin" env "${vars[@]}" "$cc" "${opts[@]}" -o "$out/$kind.o" >"$out/$kind.out" 2>"$out/$kind.err"
done
cmp "$out/plain.bin" "$out/lookup.bin"
cmp "$out/plain.bin" "$out/source.bin"
for kind in ordinary source lookup demand local-access; do cmp "$out/plain.o" "$out/$kind.o"; done
python3 "$study/graph_check.py" "$out" plain lookup ordinary > "$out/lookup.json"
python3 "$study/graph_check.py" "$out" plain local-access ordinary > "$out/local-access.json"
if python3 "$study/graph_check.py" "$out" plain demand ordinary > "$out/demand.json" 2> "$out/demand-expected-mismatch.txt"; then
    echo "Unpartitioned demands unexpectedly preserved all graph identities" >&2
    exit 1
fi
python3 "$study/control.py" "$cc" "$out/controls-initial"
for policy in uninit unused wall; do
    flags=()
    case "$policy" in uninit) flags=(-Wuninitialized);; unused) flags=(-Wunused-but-set-parameter);; wall) flags=(-Wall -Wextra);; esac
    for kind in ordinary fixed no-read no-write; do
        vars=()
        if [[ $kind != ordinary ]]; then vars=("${common[@]}" NODE_SOURCE_COMPACT=1 NODE_SOURCE_LOCAL_ACCESS=1 NODE_SOURCE_COMPACT_REPORT=1); fi
        if [[ $kind == no-read ]]; then vars+=(NODE_SOURCE_DROP_READ=1); elif [[ $kind == no-write ]]; then vars+=(NODE_SOURCE_DROP_WRITE=1); fi
        env "${vars[@]}" "$cc" --lanes 1 -c "${flags[@]}" "$study/smoke.c" -o "$out/$policy-$kind.o" >"$out/$policy-$kind.out" 2>"$out/$policy-$kind.err"
    done
done
if [[ -f $study/06-control.patch.gz ]]; then
    gzip -cd "$study/06-control.patch.gz" | git -C "$build" apply -
    (cd "$build" && ./build.sh)
    for phase in wide pruned external; do
        flags=()
        if [[ $phase == pruned ]]; then flags+=(NODE_SOURCE_PRUNED_GUARDS=1); elif [[ $phase == external ]]; then flags+=(NODE_SOURCE_STRAIGHT_GUARDS=1 NODE_SOURCE_EXTERNAL_BODY=1); else flags+=(NODE_SOURCE_STRAIGHT_GUARDS=1); fi
        env "${common[@]}" NODE_SOURCE_COMPACT=1 NODE_SOURCE_LOCAL_ACCESS=1 NODE_SOURCE_COMPACT_REPORT=1 "${flags[@]}" NODE_SOURCE_GRAPH_ORACLE="$out/$phase.bin" "$cc" "${opts[@]}" -o "$out/$phase.o" >"$out/$phase.out" 2>"$out/$phase.err"
        python3 "$study/graph_check.py" "$out" plain "$phase" ordinary > "$out/$phase.json"
        env "${flags[@]}" python3 "$study/control.py" "$cc" "$out/controls-$phase"
    done
    python3 "$study/verify-local.py" "$cc" "$out/generated"
fi
