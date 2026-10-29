#!/bin/bash
# TREE's tests on the host, each command in a lock hold of its own, into LOG: the deferred reader's fixtures, the type
# table's, the call graph, test-checker with the CI's clang 23.1.4 (the host's 23.1.1 fails four fpclassify checks: item
# 1's record), and the corpora with --deferred 8 as the 9700X job runs them (c-testsuite, the frozen sqlite3.c with
# --symbols) and the frozen musl src. Arguments: TREE LOG.
D=~/buster-fast-bench/697-cloud
cd "$D" || exit 1
tree="$1"
log="$D/$2"
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): item 2's tests on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
run()
{
    echo "== $(date -Is) $tree $*" >> "$log"
    (cd "$D/$tree" && ~/buster-fast-bench/exclusive.sh "$@") >> "$log" 2>&1
    echo "exit=$? $(date -Is)" >> "$log"
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
tool=$(ls -d ~/buster-fast-bench/unclaimed-perf-20261028/toolchain-clang2314/buster/benchpress-clang/*/ | head -1)
echo "toolchain for test-checker: $tool $("$tool/bin/clang" --version | head -1)" >> "$log"
run ./build/compiler test-checker-deferred
run ./build/compiler test-types
run ./build/compiler test-call-graph
run ./build.sh check-call-graph
run env PATH="$tool/bin:$PATH" LD_LIBRARY_PATH="$tool/lib" BUSTER_CLANG_RESOURCE_DIR="$tool/lib/clang/23" ./build/compiler test-checker --seed 133
run env -u CPATH -u C_INCLUDE_PATH ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 "$D/c-testsuite/tests/single-exec"
run env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
run env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe \
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" \
    -I "$corpus/musl-generated/obj/include" -I "$musl/include" "$musl/src"
echo "tests done $(date -Is)" >> "$log"
