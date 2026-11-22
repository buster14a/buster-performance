#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
src=$d/../active-source-name-batches/src
"$cc" -O2 -g0 -std=gnu17 -march=native -fwrapv -funsigned-char -I"$src" -I"$src/buster/compiler" ../local-spelling-study/check.c -o "$d/batches-check"
"$d/batches-check" "$d/../switch-inputs/sqlite/sqlite3.c" "$d/colliding-names.c" "$d"/../local-spelling-study/boundaries/* >"$d/batches-check.log" 2>&1

"$cc" -O3 -gline-tables-only -fno-omit-frame-pointer -std=gnu17 -march=native -fwrapv -funsigned-char -I"$src" -I"$src/buster/compiler" "$d/fresh.c" -o "$d/batches-fresh"
cd ../switch-inputs;source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
cd "$d"
PP_PRINT="$d/batches.i" ./batches-fresh "${args[@]}" >batches-preflight.tsv
cmp batches.i base.i
for round in 1 2 3;do
 if ((round%2));then arms=(fresh-base batches-fresh batches-fresh fresh-base);else arms=(batches-fresh fresh-base fresh-base batches-fresh);fi
 for arm in "${arms[@]}";do for i in {1..5};do "./$arm" "${args[@]}" >>"batch-local-$round-$arm.tsv";done;done
done
