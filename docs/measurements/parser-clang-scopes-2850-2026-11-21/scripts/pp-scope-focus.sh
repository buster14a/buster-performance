#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;until [[ -f results/scopeadmit/.built ]];do sleep 2;done
out=$root/scopeadmit-focused;mkdir -p "$out"
if ! grep -q "1024 source/policy observations" "$out/edges.log" 2>/dev/null;then
"$root/lock.sh" taskset -c 2 python3 pp-scope-boundaries.py "$root/results/enumqueuebase/compiler" "$root/results/scopeadmit/compiler" "$out/edges" > "$out/edges.log" 2>&1
fi
clang=$(sed -n "s/.*toolchain: clang \([^ ]*\) (.*/\1/p" "$root/results/scopeadmit/build.log"|head -1)
cd "$root/trees/scopeadmit"
for m in 0 1 2 3;do
 "$root/lock.sh" taskset -c 2 env BUSTER_TEST_SCOPE_ADMISSION="$m" "$root/results/scopeadmit/compiler" test-parser --clang "$clang" --seed 133 > "$out/pinned-parser-$m.out" 2>"$out/pinned-parser-$m.err"
done
date -u +%FT%TZ > "$out/done"
