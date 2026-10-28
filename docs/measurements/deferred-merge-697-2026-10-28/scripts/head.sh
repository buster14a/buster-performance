#!/bin/bash
# Item 1's PR head: build the three commits (a: the timers, b: the scan, c: the pass) in checkouts of their own, check c
# (the fixtures, test-checker, test-lanes, the corpora with --deferred 8 and the call graph), then six benchmark processes
# per build on the frozen sqlite3.c, the builds taking turns. Each step one hold of the 9700X's lock.
D=~/buster-fast-bench/697-cloud
cd "$D" || exit 1
run_in()
{
    local dir="$1" log="$2" title="$3"
    shift 3
    {
        echo "== $(date -u +%FT%TZ) $dir $*"
        (cd "$D/$dir" && EXCLUSIVE_OWNER=claude-697-cloud EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): $title" \
            EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697" ~/buster-fast-bench/exclusive.sh "$@" 2>&1)
        echo "== exit $? at $(date -u +%FT%TZ)"
    } >> "$D/$log"
    tail -1 "$D/$log" | grep -q '^== exit 0 '
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
sqlite=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
rm -f head.txt
declare -A commit=([a]=23edaa12e2b0bf61af5091e81a1cd181b8a63794 [b]=0d64856b585319de9a7c4a10646cdc9bbdd095e7 [c]=d338443184ac3a5e9181e1bbcc741b9f6e3d2e02)
for t in a b c; do
    [ -d head-$t ] || git clone -q --shared item1 head-$t
    (cd head-$t && git fetch -q ../item1 item1-pr && git checkout -q -f ${commit[$t]} && echo "head-$t: $(git log -1 --format='%h %s') $(git status --short | wc -l) changed") >> head.txt 2>&1 || exit 1
done
for t in c a b; do
    run_in head-$t head.txt "item 1 head: build $t" env BUSTER_DEBUG_INFO=0 ./build.sh || exit 1
done
run_in head-c head.txt "item 1 head: test-checker-deferred" ./build/compiler test-checker-deferred
run_in head-c head.txt "item 1 head: test-checker" ./build/compiler test-checker --seed 133
run_in head-c head.txt "item 1 head: test-lanes" ./build/compiler test-lanes
run_in head-c head.txt "item 1 head: c-testsuite with --deferred 8" ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 "$D/c-testsuite/tests/single-exec"
run_in head-c head.txt "item 1 head: frozen sqlite3.c with --deferred 8 and --symbols" env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 \
    ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols "${sqlite[@]}"
run_in head-c head.txt "item 1 head: frozen musl src with --deferred 8" env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 \
    ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 \
    -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" \
    -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "$musl/src"
run_in head-c head.txt "item 1 head: call graph check" ./build.sh check-call-graph
for round in 1 2 3 4 5 6; do
    for t in a b c; do
        run_in head-$t head.txt "item 1 head: benchmark $t, process $round" env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 \
            ./build/compiler benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features "${sqlite[@]}"
    done
done
echo "head done $(date -u +%FT%TZ)" >> chain.out
