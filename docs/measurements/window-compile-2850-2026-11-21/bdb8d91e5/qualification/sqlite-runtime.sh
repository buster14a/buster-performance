#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
d=$PWD/runtime
mkdir -p "$d"
root=${PWD%/*}
cd "$root/switch-inputs"
source ../switch-local-args.sh
eval "args=($sqlite_arguments)"
clang=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$clang" -c -O0 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I "$sqlite" "$sqlite/shell.c" -o "$d/shell.o"
"$clang" -c -O0 "${args[@]}" -o "$d/clang.o"
for source in main-fbef-clean pending-native-windows; do
 "$root/$source/build/compiler" --lanes 1 -c "${args[@]}" -o "$d/$source.o"
done
cmp "$d/main-fbef-clean.o" "$d/pending-native-windows.o"
for source in clang main-fbef-clean pending-native-windows; do
 "$clang" -no-pie "$d/shell.o" "$d/$source.o" -ldl -lpthread -lm -o "$d/$source.bin"
 for test in core dotcommands files queries; do
  cwd=$(mktemp -d "$d/$test.XXXXXXXX")
  sql="$root/pending-native-windows/tests/sqlite/$test.sql"
  if [[ $test == queries ]]; then sql=${d%/*}/queries.sql; fi
  (cd "$cwd" && timeout 30 "$d/$source.bin" -batch :memory: < "$sql") > "$d/$source.$test.stdout" 2> "$d/$source.$test.stderr" && status=0 || status=$?
  echo "$status" > "$d/$source.$test.status"
 done
done
for test in core dotcommands files queries; do
 for f in stdout stderr status; do
  for source in main-fbef-clean pending-native-windows; do cmp "$d/$source.$test.$f" "$d/clang.$test.$f"; done
 done
 wc -c "$d/clang.$test.stdout"; cat "$d/clang.$test.status"
done
