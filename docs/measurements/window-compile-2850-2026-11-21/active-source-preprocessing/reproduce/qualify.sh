#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
for tree in tiles directives safe;do
 src=$d/../active-source-$tree/src
 "$cc" -O2 -g0 -std=gnu17 -march=native -fwrapv -funsigned-char -I"$src" -I"$src/buster/compiler" ../pp-live-group-study/driver.c -o "$tree-driver"
done
failed=0
for tree in tiles directives safe;do
 sed "s@here/'pilot-driver'@here/'$tree-driver'@" edges.py >"edges-$tree.py"
 python "edges-$tree.py" >"edges-$tree.log" || failed=1
 python line-check.py "$d/$tree-driver" "$d/../pp-live-group-study/debug-base" >"$tree-random.log" || failed=1
done

src=$d/../active-source-names/src
"$cc" -O2 -g0 -std=gnu17 -march=native -fwrapv -funsigned-char -I"$src" -I"$src/buster/compiler" ../local-spelling-study/check.c -o "$d/names-check"
"$d/names-check" "$d/../switch-inputs/sqlite/sqlite3.c" "$d/colliding-names.c" "$d"/../local-spelling-study/boundaries/* >"$d/names-check.log" 2>&1

exit "$failed"
