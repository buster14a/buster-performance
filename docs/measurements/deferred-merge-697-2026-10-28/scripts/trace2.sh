#!/bin/bash
# Item 1's pass, traced: each lane's start, events and tokens times, after pass.sh; one hold each.
D=~/buster-fast-bench/697-cloud
cd "$D" || exit 1
start=$(grep -c "pass done" chain.out)
until [ "$(grep -c "pass done" chain.out)" -gt "$start" ] || grep -q "^== exit [1-9]" pass.txt; do sleep 20; done
run_in()
{
    local dir="$1" log="$2" title="$3"
    shift 3
    {
        echo "== $(date -u +%FT%TZ) $*"
        (cd "$D/$dir" && EXCLUSIVE_OWNER=claude-697-cloud EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): $title" \
            EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697" ~/buster-fast-bench/exclusive.sh "$@" 2>&1)
        echo "== exit $? at $(date -u +%FT%TZ)"
    } >> "$D/$log"
    tail -1 "$D/$log" | grep -q '^== exit 0 '
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
rm -f trace2.txt
(cd item1-trace && git checkout -q -f f1f4abfca692f046d35cb1588d10569c8a36187d && git apply ../item1-pass2.diff && git apply ../item1-pass-trace.diff && git status --short | tr "\n" " ") >> trace2.txt 2>&1 || exit 1
run_in item1-trace trace2.txt "item 1 pass trace: build" env BUSTER_DEBUG_INFO=0 ./build.sh || exit 1
run_in item1-trace trace2.txt "item 1 pass trace: benchmark-checker-deferred on sqlite3.c" env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 BUSTER_MERGE_TRACE=1 \
    ./build/compiler benchmark-checker-deferred --passes 12 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${source[@]}"
echo "trace2 done $(date -u +%FT%TZ)" >> chain.out
