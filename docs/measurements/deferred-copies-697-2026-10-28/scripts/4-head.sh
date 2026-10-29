#!/bin/bash
# The PR's code with main merged in (a trial merge of the branch's head, 4085d12, with main 9bb5060: the same code as the
# PR's head, but for docs), built from a bundle as the tree `head`, then its deferred fixtures and the three corpora with
# --deferred 8 as 3-tests.sh runs them, each command in a lock hold of its own (4-tests-head.txt). CI runs the rest.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): item 2 merged with main, tested on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
rm -rf head && mkdir head && cd head && git init -q && git fetch -q --depth 300 https://github.com/buster14a/buster.git 9bb5060ebe347de5c7a0a92ba325a7b14a567788 && git fetch -q ../backup/merge-trial.bundle item2-merge-trial:refs/heads/trial && git checkout -q --detach trial || { echo "4-head checkout failed $(date -Is)" >> "$D/chain.out"; exit 1; }
cd "$D"
(cd head && sha256sum build.sh && find src -type f | LC_ALL=C sort | xargs sha256sum) > source-head.sha256
echo "== $(date -Is) build head on $(git -C head rev-parse --short HEAD)" >> 4-builds-head.txt
(cd head && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh) >> 4-builds-head.txt 2>&1
echo "exit=$? $(date -Is)" >> 4-builds-head.txt
log="$D/4-tests-head.txt"
run()
{
    echo "== $(date -Is) head $*" >> "$log"
    (cd "$D/head" && ~/buster-fast-bench/exclusive.sh "$@") >> "$log" 2>&1
    echo "exit=$? $(date -Is)" >> "$log"
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
run ./build/compiler test-checker-deferred
run env -u CPATH -u C_INCLUDE_PATH ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 "$D/c-testsuite/tests/single-exec"
run env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
run env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe \
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" \
    -I "$corpus/musl-generated/obj/include" -I "$musl/include" "$musl/src"
echo "tests done $(date -Is)" >> "$log"
echo "4-head done $(date -Is)" >> "$D/chain.out"
