#!/usr/bin/env bash
# Run under the host's reserved Buster build and test CPU allocation.
set -euo pipefail
record=$(cd "$(dirname "$0")" && pwd)
earlier="$record/../source-call-effects-2850-2026-11-21"
public=6e9c51b9d238734468dccc03ab1b6c715449804e
repo=$(realpath "$1")
out=$(realpath -m "$2")
mkdir -p "$out"
export BUSTER_CASE_DIR="$out"
tree="$out/source"
export BUSTER_SRC="$tree"
git -C "$repo" worktree add --detach "$tree" "$public"
gzip -cd "$earlier/integrated/01-physical-calls.patch.gz" | git -C "$tree" apply -
build() {
    (cd "$tree" && ./build.sh)
    gzip -cd "$earlier/predefines.h.gz" > "$tree/build/predefines.h"
    cp "$tree/build/compiler" "$out/$1"
}
apply() { gzip -cd "$record/$1.patch.gz" | git -C "$tree" apply -; }
apply 01-census
build reader
gzip -cd "$record/01-census.patch.gz" | git -C "$tree" apply -R -
apply 02-member-arguments
build member
python3 "$record/member-cases.py" "$out/member" "$out/case-results"
cp "$record/runtime.c" "$record/uninit.c" "$out"
apply 03-debug-fault-observer
build observer
python3 "$record/mutate.py"
if [[ $# -ge 4 ]]; then
    corpora=$(realpath "$3")
    self=$(realpath "$4")
    cd "$corpora"
    source "$earlier/corpus-arguments.sh"
    main_args="-march=native -I$self/src -fwrapv -funsigned-char --predefines $tree/build/predefines.h $self/src/buster/compiler/main.c"
    BUSTER_ARGS_CENSUS=1 "$out/reader" --lanes 1 --node-window-calls -c $sqlite_arguments -o "$out/census.o" 2>"$out/sqlite-census.txt"
    python3 "$record/analyze-census.py" "$out/sqlite-census.txt"
    NODE_SOURCE_GRAPH_ORACLE="$out/sqlite-ordinary.graph" "$out/member" --lanes 1 --node-window -c $sqlite_arguments -o "$out/ordinary.o"
    BUSTER_WINDOW_CALL_LOG=1 "$out/member" --lanes 1 --node-window-calls -c $sqlite_arguments -o "$out/call-parent.o" 2>"$out/call-parent.log"
    python3 "$record/graph-census.py" "$out/sqlite-ordinary.graph" "$out/call-parent.log"
    python3 "$record/quick-corpus.py" "$out/member" "$out/corpus.tsv" "$sqlite_arguments" "$lua_arguments" "$musl_arguments" "$main_args"
    python3 "$record/active-graphs.py" "$out/member" "$sqlite_arguments" "$lua_arguments" "$musl_arguments" "$main_args"
    BUSTER_CALL_FORCE_DEBUG=1 BUSTER_MEMBER_DEBUG_POLICIES=1 python3 "$record/quick-corpus.py" "$out/observer" "$out/debug-corpus.tsv" "$sqlite_arguments" "$lua_arguments" "$musl_arguments" "$main_args"
fi
