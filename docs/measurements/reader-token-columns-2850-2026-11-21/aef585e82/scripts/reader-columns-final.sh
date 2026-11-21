#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
export col_root=$PWD
out=$PWD/reader-columns-final
export PATH="/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
for tag in reader-token-columns reader-token-parent; do
 cd "$col_root/$tag"
 ./build.sh >"$out/$tag-build.log" 2>&1
 cp ../buster/build/predefines.h build/
done
cd "$col_root/reader-token-columns"
cc=$PWD/build/compiler
ref=$col_root/reader-token-parent/build/compiler
for part in 5 1 2 3 4 6 7 8; do
 "$cc" test-checker --part "$part/8" --seed 133 > "$out/shard$part.log" 2>&1 || fail=$?
done
python3 ../return-query-fixtures.py "$ref" "$cc" "$out/return" >"$out/return.log" || fail=$?
python3 ../pretty-fixtures.py "$ref" "$cc" "$out/pretty" >"$out/pretty.log" || fail=$?
cd ../switch-inputs
source "$col_root/switch-local-args.sh"
for mode in default warnings;do
 extra=(); [[ $mode != warnings ]] || extra=(-Wall -Wextra)
 for group in sqlite lua musl;do
  var=${group}_arguments
  eval "opts=(${!var})"
  python3 "$col_root/reader-columns-final-objects.py" "$group-$mode" "${extra[@]}" "${opts[@]}" || fail=$?
 done
done
echo "${fail:-0}" > "$out/status"
exit "${fail:-0}"
