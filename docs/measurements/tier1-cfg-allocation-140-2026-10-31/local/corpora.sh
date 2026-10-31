#!/usr/bin/env bash
# corpora.sh TREE LOGS: test-tier1-cfg-source on c-testsuite's subset, the frozen sqlite3.c and musl's units, with the
# 9700X job's options for each, from TREE's build, each command's output in LOGS.
set -u
tree=$1
logs=$2
corpus=${BUSTER_CORPUS:-$HOME/.cache/claude-174/corpus}
ct=${C_TESTSUITE:-$HOME/.cache/fuzz-corpus/c-testsuite}
musl="$corpus/libc/musl"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
mkdir -p "$logs"
cd "$tree" || exit 1
run()
{
    local name=$1
    shift
    local start end
    start=$(date +%s.%N)
    ./build/compiler test-tier1-cfg-source "$@" > "$logs/$name.log" 2>&1
    local status=$?
    end=$(date +%s.%N)
    echo "exit $status seconds $(echo "$end - $start" | bc)" >> "$logs/$name.log"
}
run c-testsuite $(sed -n "s|^\([0-9][0-9]*\)$|$ct/tests/single-exec/\1.c|p" tests/c-testsuite/subset.txt)
run sqlite --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
run musl --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os \
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
    "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c
for name in c-testsuite sqlite musl; do
    echo "== $name"
    grep -E "totals|path=|frame traffic|^exit" "$logs/$name.log"
    grep -cE "refused=|rejected=|error=|unpromoted|malformed" "$logs/$name.log"
done
