#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;out=$root/scopeadmit-positive;mkdir -p "$out"
python3 pp-scope-positive.py "$out/files"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/scopeadmit/build.log"|head -1)
for tag in enumqueuebase scopeadmit;do
 "$root/lock.sh" taskset -c 2 "$clang" -DPROBE_IDENTITY -std=gnu17 -O1 -g0 -march=znver5 -fwrapv -funsigned-char -I"$root/trees/$tag/src" "$out/scope-witness.c" -o "$out/$tag-oracle" >"$out/$tag.build" 2>&1
done
for mode in 0 1 2 3;do
 tag=scopeadmit;[[ $mode != 0 ]] || tag=enumqueuebase;p=$out/$mode
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.record"' _ "$p" env BUSTER_TEST_SCOPE_ADMISSION="$mode" "$out/$tag-oracle" -std=c23 -- "$out"/files/*.c >"$p.lock" 2>&1
 cmp "$out/0.data" "$p.data";cmp "$out/0.record" "$p.record"
 sha256sum "$p.data" >"$p.sha256";wc -c "$p.data">"$p.bytes";[[ $mode == 0 ]] || rm "$p.data"
 grep -Eq 'scope-witness .*replay=1 converted=1' "$p.record";grep -Eq 'scope-witness .*deferred=1 replay=0 converted=0' "$p.record"
 grep -Eq 'scope-witness .*deferred=0 replay=1 converted=0' "$p.record"
 test "$(grep -c '^scope-witness ' "$p.record")" = 108
 echo "$mode">>"$out/status"
done
rm "$out/0.data";date -u +%FT%TZ >"$out/done"
