#!/usr/bin/env bash
set -euo pipefail
mode=$1
kind=$2
out=$3
scalar=$4
copies=${5:-}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
extra="-march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include --predefines $corpus/provenance/gnu17-pinned-predefines.txt"
if [ "$kind" = sqlite ]; then
    input="$corpus/sqlite/sqlite3.c"
elif [ "$kind" = lua ]; then
    lua="$HOME/buster-fast-bench/codex-926-lua-174afc-20261030/inputs/lua-5.4.8"
    input="$lua/src/lua.c"
    extra="$extra -I $lua/src"
else
    echo "unknown kind $kind" >&2
    exit 2
fi
[ "$scalar" = yes ] && extra="$extra --scalar"
exec python3 /tmp/opencode-883-timing.py \
    --root "$HOME/buster-fast-bench/codex-883-takeover-20261031" \
    --input "$input" --out "$HOME/buster-fast-bench/codex-883-takeover-20261031/timing/$out" \
    --mode "$mode" --extra "$extra" --copies "$copies" --runs 18 --warmups 2 --tag "$out"
