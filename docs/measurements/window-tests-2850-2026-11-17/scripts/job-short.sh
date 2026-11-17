#!/bin/bash
# job-short.sh LABEL PATCH [READINGS]: a variant of the piece (PATCH against main BASE), its window's tests alone:
# READINGS readings (default 3) on sqlite3.c and Lua, one on musl.
cd "$(dirname "$0")"
label=$1; patch=$2; readings=${3:-3}
base=${BASE:-0e8342dd7f1be0c07b97e9c6ec8dc2413887ef06}
./build-label.sh "$label" $base "$patch" || exit 1
./turns.sh "" "$readings" "sqlite3 lua" "$label window-tests --shadow --passes 0 --window-tests" || exit 1
./turns.sh "" 1 "musl" "$label window-tests --shadow --passes 0 --window-tests" || exit 1
echo job finished
