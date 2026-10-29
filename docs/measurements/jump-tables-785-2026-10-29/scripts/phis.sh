#!/bin/bash
# sqlite3VdbeExec's promoted phis and phi pairs, and benchmark-ir-source's bytes, of the frozen sqlite3.c by one compiler.
compiler=$1
out=$2
corpus=$HOME/.cache/claude-frozen-corpus
opts=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
"$compiler" test-ir-source --print sqlite3VdbeExec "${opts[@]}" "$corpus/sqlite/sqlite3.c" > "$out.print" 2>&1
echo "test-ir-source exit $?"
grep '^ir-source: totals' "$out.print"
awk '/as promoted:/{p=1} /as lowered:/{p=0} p && / = phi\./{pairs += gsub(/\[%/, "[%"); phis += 1} END {printf "sqlite3VdbeExec promoted: %d phis, %d pairs\n", phis, pairs}' "$out.print"
awk '/as lowered:/{p=1} /as promoted:/{p=0} p && / = br_indirect\./{n += 1} END {printf "sqlite3VdbeExec lowered: %d br_indirect\n", n}' "$out.print"
"$compiler" benchmark-ir-source --only lower "${opts[@]}" "$corpus/sqlite/sqlite3.c" > "$out.bench" 2>&1
grep -i 'bytes\|largest\|sqlite3VdbeExec' "$out.bench" | head -12
