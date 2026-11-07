#!/bin/bash
# Sizes the use-list builder on the 9700X at main: benchmark-ir's uses and verifier paths, and ir_uses_validated's share
# of a -c --tier1 compile of the frozen sqlite3.c and of the optimizer on its IR. One process per lock, CPU 2.
set -u
D=$HOME/buster-fast-bench/uses-claude
cd "$D" || exit 1
while pgrep -f '[s]etup.sh' > /dev/null; do sleep 20; done
grep -q 'published as build/compiler' build-main.log || { echo "uses-measure: main's build failed"; exit 1; }
export EXCLUSIVE_OWNER=claude-uses EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQt3vr5GH2UtvS3ETV7
LOCK=$HOME/buster-fast-bench/exclusive.sh
C=main/build/compiler
OUT=$D/results
mkdir -p "$OUT"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
sqlite="$corpus/sqlite/sqlite3.c"
EXCLUSIVE_TITLE="uses: benchmark-ir" "$LOCK" taskset -c 2 "$C" benchmark-ir > "$OUT/benchmark-ir.log" 2>&1
EXCLUSIVE_TITLE="uses: tier1 profile" "$LOCK" taskset -c 2 perf record -e cycles -F 4999 -g -o "$OUT/perf-tier1.data" "$C" -c --tier1 --lanes 1 "${driver[@]}" -w -o "$OUT/tier1.o" "$sqlite" > "$OUT/perf-tier1.log" 2>&1
perf report -i "$OUT/perf-tier1.data" --no-children --sort sym -g none 2> /dev/null | grep -v '^#' | grep '%' | head -60 > "$OUT/perf-tier1.report"
perf report -i "$OUT/perf-tier1.data" --children --sort sym -g none 2> /dev/null | grep -v '^#' | grep -E 'ir_uses_validated|ir_optimize_prepare|ir_optimize\b|check_tier1_compile|ir_check_rows' > "$OUT/perf-tier1.children"
EXCLUSIVE_TITLE="uses: optimizer profile" "$LOCK" taskset -c 2 perf record -e cycles -F 4999 -o "$OUT/perf-optimize.data" "$C" benchmark-ir-source --only optimize "${source[@]}" "$sqlite" > "$OUT/perf-optimize.log" 2>&1
perf report -i "$OUT/perf-optimize.data" --no-children --sort sym 2> /dev/null | grep -v '^#' | grep '%' | head -40 > "$OUT/perf-optimize.report"
echo "uses-measure: done"
