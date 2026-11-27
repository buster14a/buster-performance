#!/bin/bash
set -euo pipefail
root=${GVN_RUN_DIR:?Set GVN_RUN_DIR to the experiment directory}
corpus=${GVN_CORPUS:?Set GVN_CORPUS to the prepared compiler corpus root}
musl=$corpus/libc/musl
lua=${GVN_LUA:?Set GVN_LUA to the Lua 5.4.8 src directory}
export LC_ALL=C
executable=$1; mode=$2; group=$3; choice=$4; round=$5
case "$group" in
sqlite) args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c");;
lua) args=("$lua"/*.c);;
musl) args=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"); declare -A seen; for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; args+=("$f"); fi; done;;
*) exit 2;;
esac
case "$mode" in
 default) flags=();;
 all) flags=(--tier1-passes=+all);;
 numbering) flags=(--tier1-passes=+numbering);;
 *) exit 2;;
esac
out="$root/objects/$executable-$mode-$group-$choice"
mkdir -p "$out" "$root/logs"
cd "$out"
export BUSTER_EXPERIMENT_GVN_PATH="$choice"
"$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 240 taskset -c 2 "$root/$executable" -c --tier1 --lanes 1 "${flags[@]}" "${args[@]}" > "$root/logs/$executable-$mode-$group-$choice-$round.out" 2> "$root/logs/$executable-$mode-$group-$choice-$round.log"
